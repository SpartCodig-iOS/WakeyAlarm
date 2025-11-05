//
//  StopWatchTimer.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/4/25.
//

import Foundation
import SwiftUI

// MARK: - StopWatch Timer Manager
@MainActor
final class StopWatchTimer {

  private var ticker: Task<Void, Never>?
  private weak var intent: StopWatchIntent?

  init(intent: StopWatchIntent) {
    self.intent = intent
  }

  deinit {
    // deinit는 동기적으로만 실행 가능
    ticker?.cancel()
    ticker = nil
  }

  // MARK: - Timer Control

  func start() {
    stop()

    ticker = Task { @MainActor [weak self] in
      guard let self = self else { return }
      let clock = ContinuousClock()
      var lastUpdateTime = Date()

      while !Task.isCancelled {
        try? await clock.sleep(for: .milliseconds(10))

        guard let intent = self.intent else { break }                // ← 옵셔널 언랩
        guard let started = intent.state.startedAt else { continue }

        let elapsed = Date().timeIntervalSince(started)
        intent.state = intent.reduce(intent.state, .setElapsed(elapsed))

        let now = Date()
        if now.timeIntervalSince(lastUpdateTime) >= 1.0 {
          lastUpdateTime = now
          intent.updateLiveActivity()
        }

        let minuteIndex = Int(elapsed / 60.0)
        if minuteIndex != intent.state.previousMinuteIndex {
          intent.state = intent.reduce(intent.state, .setPreviousMinuteIndex(minuteIndex))

          let seconds = elapsed.truncatingRemainder(dividingBy: 60)
          let currentProgress = max(CGFloat(seconds / 60.0), 0.001)
          intent.state = intent.reduce(intent.state, .setResetAnimationTrimAmount(currentProgress))
          intent.state = intent.reduce(intent.state, .incrementMinuteWrapCount)

          Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(1))
            intent.state = intent.reduce(intent.state, .setResetAnimationTrimAmount(0))
          }
        }
      }
    }
  }

  func stop() {
    ticker?.cancel()
    ticker = nil
  }
}
