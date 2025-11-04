import Foundation
import SwiftUI

#if canImport(ActivityKit)
@preconcurrency import ActivityKit
#endif

@MainActor
public protocol StopWatchWidgetActivityDelegate: AnyObject {
  func startLiveActivity(
    elapsedTime: TimeInterval,
    isRunning: Bool,
    lapCount: Int,
    currentLapTime: TimeInterval?,
    startTime: Date?
  )

  func updateLiveActivity(
    elapsedTime: TimeInterval,
    isRunning: Bool,
    lapCount: Int,
    currentLapTime: TimeInterval?,
    startTime: Date?
  )

  func endLiveActivity()
}

@MainActor
public final class WidgetActivityManager: ObservableObject, StopWatchWidgetActivityDelegate {
  @Published public private(set) var isActivityActive: Bool = false
  private var currentActivityId: String?

  public static let shared = WidgetActivityManager()
  private init() {}

  public func startLiveActivity(
    elapsedTime: TimeInterval,
    isRunning: Bool,
    lapCount: Int,
    currentLapTime: TimeInterval?,
    startTime: Date?
  ) {
    #if canImport(ActivityKit)
    guard #available(iOS 16.1, *) else { return }

    let authInfo = ActivityAuthorizationInfo()
    guard authInfo.areActivitiesEnabled else {
      print("❌ Live Activities가 비활성화되어 있습니다.")
      return
    }

    if let _ = findCurrentActivity() {
      updateLiveActivity(
        elapsedTime: elapsedTime,
        isRunning: isRunning,
        lapCount: lapCount,
        currentLapTime: currentLapTime,
        startTime: startTime
      )
      return
    }

    Task { [weak self] in
      await self?.createNewActivity(
        elapsedTime: elapsedTime,
        isRunning: isRunning,
        lapCount: lapCount,
        currentLapTime: currentLapTime,
        startTime: startTime
      )
    }
    #endif
  }

  public func updateLiveActivity(
    elapsedTime: TimeInterval,
    isRunning: Bool,
    lapCount: Int,
    currentLapTime: TimeInterval?,
    startTime: Date?
  ) {
    #if canImport(ActivityKit)
    guard #available(iOS 16.1, *), let activityId = currentActivityId else { return }

    Task { @Sendable in
      let activities = Activity<StopWatchActivityAttributes>.activities
      guard let target = activities.first(where: { $0.id == activityId }) else { return }

      let state = StopWatchActivityAttributes.ContentState(
        elapsedTime: elapsedTime,
        isRunning: isRunning,
        lapCount: lapCount,
        currentLapTime: currentLapTime,
        startTime: startTime
      )
      let staleDate = Date().addingTimeInterval(2)
      await target.update(.init(state: state, staleDate: staleDate))
    }
    #endif
  }

  public func endLiveActivity() {
    #if canImport(ActivityKit)
    guard #available(iOS 16.1, *), let activityId = currentActivityId else { return }

    Task { @Sendable in
      let activities = Activity<StopWatchActivityAttributes>.activities
      guard let target = activities.first(where: { $0.id == activityId }) else { return }
      await target.end(nil, dismissalPolicy: .immediate)

      await MainActor.run {
        self.isActivityActive = false
        self.currentActivityId = nil
      }
    }
    #endif
  }

  // MARK: - Diagnostics

  public func cleanup() async {
    #if canImport(ActivityKit)
    if #available(iOS 16.1, *) {
      await cleanupAllActivities()
    }
    #endif
  }

  public var activityAuthorizationStatus: String {
    #if canImport(ActivityKit)
    if #available(iOS 16.1, *) {
      return ActivityAuthorizationInfo().areActivitiesEnabled ? "허용됨" : "비허용"
    }
    #endif
    return "미지원"
  }

  public var activeActivityCount: Int {
    #if canImport(ActivityKit)
    if #available(iOS 16.1, *) {
      return Activity<StopWatchActivityAttributes>.activities.count
    }
    #endif
    return 0
  }

  public func diagnoseLiveActivityStatus() {
    #if canImport(ActivityKit)
    guard #available(iOS 16.1, *) else { return }

    let authInfo = ActivityAuthorizationInfo()
    print("🔐 Live Activities 권한: \(authInfo.areActivitiesEnabled)")
    let activities = Activity<StopWatchActivityAttributes>.activities
    print("📊 현재 활성 Activity 수: \(activities.count)")
    for activity in activities {
      print("• Activity: \(activity.id) - 상태: \(activity.activityState)")
    }
    #endif
  }

  // MARK: - Helpers

  #if canImport(ActivityKit)
  @available(iOS 16.1, *)
  private func findCurrentActivity() -> Activity<StopWatchActivityAttributes>? {
    guard let id = currentActivityId else { return nil }
    return Activity<StopWatchActivityAttributes>.activities.first(where: { $0.id == id })
  }

  @available(iOS 16.1, *)
  private func createNewActivity(
    elapsedTime: TimeInterval,
    isRunning: Bool,
    lapCount: Int,
    currentLapTime: TimeInterval?,
    startTime: Date?
  ) async {
    await cleanupAllActivities()

    let attributes = StopWatchActivityAttributes(name: "스톱워치")
    let contentState = StopWatchActivityAttributes.ContentState(
      elapsedTime: elapsedTime,
      isRunning: isRunning,
      lapCount: lapCount,
      currentLapTime: currentLapTime,
      startTime: startTime
    )

    do {
      let activity = try Activity<StopWatchActivityAttributes>.request(
        attributes: attributes,
        content: .init(state: contentState, staleDate: Date().addingTimeInterval(10))
      )

      await MainActor.run {
        self.currentActivityId = activity.id
        self.isActivityActive = true
      }
    } catch {
      await MainActor.run {
        self.currentActivityId = nil
        self.isActivityActive = false
      }
      print("❌ Live Activity 생성 실패: \(error)")
    }
  }

  @available(iOS 16.1, *)
  private func cleanupAllActivities() async {
    let activities = Activity<StopWatchActivityAttributes>.activities
    guard !activities.isEmpty else { return }

    for activity in activities {
      await activity.end(nil, dismissalPolicy: .immediate)
    }

    await MainActor.run {
      self.currentActivityId = nil
      self.isActivityActive = false
    }
  }
  #endif
}

#if canImport(ActivityKit)
@available(iOS 16.1, *)
public struct StopWatchActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    public var elapsedTime: TimeInterval
    public var isRunning: Bool
    public var lapCount: Int
    public var currentLapTime: TimeInterval?
    public var startTime: Date?

    public init(
      elapsedTime: TimeInterval,
      isRunning: Bool,
      lapCount: Int,
      currentLapTime: TimeInterval?,
      startTime: Date?
    ) {
      self.elapsedTime = elapsedTime
      self.isRunning = isRunning
      self.lapCount = lapCount
      self.currentLapTime = currentLapTime
      self.startTime = startTime
    }

    public var formattedElapsedTime: String {
      let total = isRunning && startTime != nil ? Date().timeIntervalSince(startTime!) + elapsedTime : elapsedTime
      let minutes = Int(total) / 60
      let seconds = Int(total) % 60
      let hundredths = Int((total.truncatingRemainder(dividingBy: 1)) * 100)
      return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }

    public var formattedCurrentLapTime: String {
      guard let currentLapTime else { return "00:00.00" }
      let minutes = Int(currentLapTime) / 60
      let seconds = Int(currentLapTime) % 60
      let hundredths = Int((currentLapTime.truncatingRemainder(dividingBy: 1)) * 100)
      return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
  }

  public var name: String

  public init(name: String) {
    self.name = name
  }
}
#endif
