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
  @Published public private(set) var state: State = .init()

  public struct State: Equatable {
    var elapsed: TimeInterval = 0
    var isRunning: Bool = false
    var startedAt: Date? = nil
    var laps: [TimeInterval] = []
    var error: String? = nil

    // ⬇️ View에서 쓰던 애니메이션 상태까지 전부 Intent State로 관리
    var resetAnimationTrimAmount: CGFloat = 0          // 보조 링 길이
    var minuteWrapCount: Int = 0                       // 60초 경계 통과 횟수
    var previousMinuteIndex: Int? = nil                // 직전 분 인덱스(경계 감지용)
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

  private var ticker: Task<Void, Never>?

  public func intent(_ userIntent: UserIntent) {
    switch userIntent {
    case .startTapped:
      guard !state.isRunning else { return }
      let anchor = Date().addingTimeInterval(-state.elapsed)
      state = reduce(state, .setStartedAt(anchor))
      state = reduce(state, .setRunning(true))
      // 현재 분 인덱스로 초기화
      state = reduce(state, .setPreviousMinuteIndex(Int(state.elapsed / 60)))
      startTicker()

    case .stopTapped:
      guard state.isRunning else { return }
      ticker?.cancel(); ticker = nil
      state = reduce(state, .setRunning(false))
      state = reduce(state, .setStartedAt(nil))

    case .lapTapped:
      guard state.isRunning else { return }
      state = reduce(state, .pushLap(state.elapsed))

    case .resetTapped:
      ticker?.cancel(); ticker = nil
      state = reduce(state, .setRunning(false))
      state = reduce(state, .setStartedAt(nil))
      state = reduce(state, .setElapsed(0))
      state = reduce(state, .clearLaps)
      state = reduce(state, .setError(nil))
      state = reduce(state, .setResetAnimationTrimAmount(0))
      state = reduce(state, .setPreviousMinuteIndex(0))
      state = reduce(state, .incrementMinuteWrapCount)
    }
  }

  private func startTicker() {
    ticker?.cancel()
    ticker = Task { [weak self] in
      guard let self else { return }
      let clock = ContinuousClock()
      while !Task.isCancelled {
        try? await clock.sleep(for: .milliseconds(10))
        guard let started = self.state.startedAt else { continue }

        let elapsed = Date().timeIntervalSince(started)
        self.state = self.reduce(self.state, .setElapsed(elapsed))

        // 60초 경계 감지: 분 인덱스가 바뀌면 wrap 이벤트
        let minuteIndex = Int(elapsed / 60.0)
        if minuteIndex != self.state.previousMinuteIndex {
          self.state = self.reduce(self.state, .setPreviousMinuteIndex(minuteIndex))

          // 현재 진행도(0~1)를 보조 링에 복사
          let seconds = elapsed.truncatingRemainder(dividingBy: 60)
          let currentProgress = max(CGFloat(seconds / 60.0), 0.001)
          self.state = self.reduce(self.state, .setResetAnimationTrimAmount(currentProgress))
          self.state = self.reduce(self.state, .incrementMinuteWrapCount)

          // 0.18초 뒤 0으로 → “슥” 줄어드는 초기화 하는 애니메이션
          Task { [weak self] in
            guard let self else { return }
            try? await clock.sleep(for: .milliseconds(180))
            self.state = self.reduce(self.state, .setResetAnimationTrimAmount(0))
          }
        }
      }
    }
  }

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

  // 표시용 유틸
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
