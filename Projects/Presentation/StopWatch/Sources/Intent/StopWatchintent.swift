//
//  StopWatchIntent.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/4/25.
//

import Foundation
import SwiftUI
import Utill

@MainActor
public final class StopWatchIntent: ObservableObject {
  @Published public var state: State = .init()

  public weak var widgetActivityDelegate: StopWatchWidgetActivityDelegate?

  private var timer: StopWatchTimer?
  private var background: StopWatchBackground?

  public init() {
    timer = StopWatchTimer(intent: self)
    background = StopWatchBackground(intent: self)
  }

  deinit {
    timer = nil
    background = nil
  }

  public struct State: Equatable {
    var elapsed: TimeInterval = 0
    var isRunning: Bool = false
    var startedAt: Date? = nil
    var laps: [TimeInterval] = []
    var error: String? = nil

    var resetAnimationTrimAmount: CGFloat = 0
    var minuteWrapCount: Int = 0
    var previousMinuteIndex: Int? = nil
  }

  public enum UserIntent: Equatable {
    case startTapped, stopTapped, lapTapped, resetTapped
  }

  public enum Action: Equatable {
    case setRunning(Bool)
    case setElapsed(TimeInterval)
    case setStartedAt(Date?)
    case pushLap(TimeInterval)
    case clearLaps
    case setError(String?)

    case setResetAnimationTrimAmount(CGFloat)
    case incrementMinuteWrapCount
    case setPreviousMinuteIndex(Int?)
  }
  // MARK: - Delegate Configuration

  public func setWidgetActivityDelegate(_ delegate: StopWatchWidgetActivityDelegate?) {
    widgetActivityDelegate = delegate
    if delegate != nil {
      print("✅ WidgetActivityDelegate 설정 완료")
    } else {
      print("⚠️ WidgetActivityDelegate 제거됨")
    }
  }

  // MARK: - Live Activity Interface

  func updateLiveActivity() {
    let currentLapTime = state.laps.isEmpty ? nil : (state.elapsed - (state.laps.first ?? 0))
    widgetActivityDelegate?.updateLiveActivity(
      elapsedTime: state.elapsed,
      isRunning: state.isRunning,
      lapCount: state.laps.count,
      currentLapTime: currentLapTime,
      startTime: state.startedAt
    )
  }

  // MARK: - User Intents

  public func intent(_ userIntent: UserIntent) {
    switch userIntent {
    case .startTapped:
      guard !state.isRunning else { return }
      let anchor = Date().addingTimeInterval(-state.elapsed)
      state = reduce(state, .setStartedAt(anchor))
      state = reduce(state, .setRunning(true))
      state = reduce(state, .setPreviousMinuteIndex(Int(state.elapsed / 60)))
      timer?.start()
      let currentLapTime = state.laps.isEmpty ? nil : (state.elapsed - (state.laps.first ?? 0))
      widgetActivityDelegate?.startLiveActivity(
        elapsedTime: state.elapsed,
        isRunning: state.isRunning,
        lapCount: state.laps.count,
        currentLapTime: currentLapTime,
        startTime: state.startedAt
      )

    case .stopTapped:
      guard state.isRunning else { return }
      timer?.stop()
      state = reduce(state, .setRunning(false))
      state = reduce(state, .setStartedAt(nil))
      updateLiveActivity()

    case .lapTapped:
      guard state.isRunning else { return }
      state = reduce(state, .pushLap(state.elapsed))
      updateLiveActivity()

    case .resetTapped:
      timer?.stop()
      state = reduce(state, .setRunning(false))
      state = reduce(state, .setStartedAt(nil))
      state = reduce(state, .setElapsed(0))
      state = reduce(state, .clearLaps)
      state = reduce(state, .setError(nil))
      state = reduce(state, .setResetAnimationTrimAmount(0))
      state = reduce(state, .setPreviousMinuteIndex(0))
      state = reduce(state, .incrementMinuteWrapCount)
      background?.resetLiveActivityFlag()
      widgetActivityDelegate?.endLiveActivity()
    }
  }

  // MARK: - Reducer

  public func reduce(_ state: State, _ action: Action) -> State {
    var newState = state
    switch action {
    case let .setRunning(flag):
        newState.isRunning = flag
      case let .setElapsed(elapsed):
        newState.elapsed = elapsed
    case let .setStartedAt(date):
      newState.startedAt = date
    case let .pushLap(time):
        newState.laps.insert(time, at: 0)
    case .clearLaps:
        newState.laps.removeAll()
    case let .setError(error):
        newState.error = error
    case let .setResetAnimationTrimAmount(value):
        newState.resetAnimationTrimAmount = value
    case .incrementMinuteWrapCount:
        newState.minuteWrapCount += 1
    case let .setPreviousMinuteIndex(index):
        newState.previousMinuteIndex = index
    }
    return newState
  }

  // MARK: - Display Utilities
  public var formattedMain: String {
    let t = state.elapsed
    return String(format: "%02d:%02d", Int(t) / 60, Int(t) % 60)
  }

  public var formattedHundredths: String {
    let t = state.elapsed
    return String(format: ".%02d", Int((t - floor(t)) * 100))
  }

  public var circleProgress: CGFloat {
    let seconds = state.elapsed.truncatingRemainder(dividingBy: 60)
    return CGFloat(seconds / 60.0)
  }
}
