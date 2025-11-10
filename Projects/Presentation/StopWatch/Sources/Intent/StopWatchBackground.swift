//
//  StopWatchBackground.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/4/25.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - StopWatch Background Manager
@MainActor
final class StopWatchBackground {

  private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
  private var backgroundUpdateTask: Task<Void, Never>?
  private var hasActiveLiveActivity: Bool = false
  private weak var intent: StopWatchIntent?

  init(intent: StopWatchIntent) {
    self.intent = intent
    setupBackgroundHandling()
  }

  @MainActor deinit {
    cleanup()
  }

  // MARK: - Background Lifecycle

  private func setupBackgroundHandling() {
    // 백그라운드/포그라운드 전환 알림 등록
    NotificationCenter.default.addObserver(
      forName: UIApplication.didEnterBackgroundNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor in
        self?.handleDidEnterBackground()
      }
    }

    NotificationCenter.default.addObserver(
      forName: UIApplication.willEnterForegroundNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      Task { @MainActor in
        self?.handleWillEnterForeground()
      }
    }
  }

  private func cleanup() {
    backgroundUpdateTask?.cancel()
    endBackgroundTask()
    NotificationCenter.default.removeObserver(self)
    intent?.widgetActivityDelegate?.endLiveActivity()
  }

  // MARK: - Background Handling

  private func handleDidEnterBackground() {
    guard let intent = intent else { return }

    // 스톱워치가 실행 중일 때만 Live Activity 시작
    guard intent.state.isRunning else {
      print("⚠️ 스톱워치가 실행 중이 아니므로 Live Activity를 시작하지 않습니다.")
      return
    }

    // 이미 Live Activity가 활성화되어 있다면 중복 요청 방지
    guard !hasActiveLiveActivity else {
      print("⚠️ Live Activity가 이미 활성화되어 있습니다. 업데이트로 처리합니다.")
      intent.updateLiveActivity()
      return
    }

    print("🏝️ 백그라운드 전환 - Live Activity 시작 준비")

    // Background Task 시작 - 백그라운드에서 더 오래 실행 허용
    startBackgroundTask()

    // Live Activity 요청 전 플래그 설정
    hasActiveLiveActivity = true

    let currentLapTime = intent.state.laps.isEmpty ? nil : (intent.state.elapsed - (intent.state.laps.first ?? 0))

    // 딜리게이트가 있는지 확인
    guard let delegate = intent.widgetActivityDelegate else {
      print("❌ WidgetActivityDelegate가 설정되지 않았습니다.")
      hasActiveLiveActivity = false
      return
    }

    print("📋 Live Activity 시작 요청: elapsed=\(intent.state.elapsed), running=\(intent.state.isRunning), laps=\(intent.state.laps.count)")

    delegate.startLiveActivity(
      elapsedTime: intent.state.elapsed,
      isRunning: intent.state.isRunning,
      lapCount: intent.state.laps.count,
      currentLapTime: currentLapTime,
      startTime: intent.state.startedAt
    )

    print("🏝️ Dynamic Island 활성화 요청됨 (백그라운드 전환)")

    // 백그라운드에서 더 자주 업데이트하도록 설정
    scheduleBackgroundUpdates()
  }

  private func handleWillEnterForeground() {
    // 포그라운드로 돌아올 때 Background Task 종료
    endBackgroundTask()

    // Live Activity 플래그 리셋 (포그라운드에서는 새로 시작 가능)
    hasActiveLiveActivity = false

    print("📱 앱이 포그라운드로 돌아왔습니다")
  }

  // MARK: - Background Task Management

  private func startBackgroundTask() {
    endBackgroundTask() // 기존 작업이 있다면 종료

    backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "StopwatchTimer") { [weak self] in
      self?.endBackgroundTask()
    }
    print("🔄 백그라운드 작업 시작됨: \(backgroundTask)")
  }

  private func endBackgroundTask() {
    if backgroundTask != .invalid {
      UIApplication.shared.endBackgroundTask(backgroundTask)
      backgroundTask = .invalid
      print("⏹️ 백그라운드 작업 종료됨")
    }
  }

  private func scheduleBackgroundUpdates() {
    // 기존 업데이트 Task 정리
    backgroundUpdateTask?.cancel()

    // 메모리 효율적인 백그라운드 업데이트 (Sendable 안전)
    backgroundUpdateTask = Task { @MainActor in
      var updateCount = 0
      let maxUpdates = 30 // 최대 30회 업데이트 (약 30초)

      while !Task.isCancelled &&
            backgroundTask != .invalid &&
            updateCount < maxUpdates &&
            intent?.state.isRunning == true {

        try? await Task.sleep(for: .seconds(1))

        // Task 취소 체크
        guard !Task.isCancelled else { break }
        guard intent?.state.isRunning == true else { break }

        // 매초마다 Live Activity 업데이트 (메모리 효율적)
        intent?.updateLiveActivity()
        updateCount += 1
        print("🏝️ 백그라운드 업데이트 #\(updateCount)")
      }

      backgroundUpdateTask = nil
      print("🔚 백그라운드 업데이트 완료")
    }
  }

  // MARK: - Public Interface

  func resetLiveActivityFlag() {
    hasActiveLiveActivity = false
  }
}
