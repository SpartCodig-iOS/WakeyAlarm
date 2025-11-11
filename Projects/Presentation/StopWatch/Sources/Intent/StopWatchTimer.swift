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

  // MARK: - Public API
  func start() {
    stop()

    ticker = Task { @MainActor [weak self] in
      guard let self else { return }
      await self.runTicker()
    }
  }

  func stop() {
    ticker?.cancel()
    ticker = nil
  }

  // MARK: - Private Helpers

  /// 메인 타이머 루프
  private func runTicker() async {
    let clock = ContinuousClock()
    var lastUpdateTime = Date()

    while !Task.isCancelled {
      // 10ms 간격
      try? await clock.sleep(for: .milliseconds(10))

      guard let intent = intent else { break }
      guard let startedAt = intent.state.startedAt else { continue }

      // 경과 시간 업데이트
      let elapsed = Date().timeIntervalSince(startedAt)
      apply(intent, .setElapsed(elapsed))

      // 1초마다 Live Activity 갱신
      let now = Date()
      if now.timeIntervalSince(lastUpdateTime) >= 1 {
        lastUpdateTime = now
        intent.updateLiveActivity()
      }

      // 분 변경 처리
      handleMinuteChange(intent: intent, elapsed: elapsed)
    }
  }

  /// state 업데이트 공통 처리
  private func apply(_ intent: StopWatchIntent, _ action: StopWatchIntent.Action) {
    intent.state = intent.reduce(intent.state, action)
  }

  /// 분이 바뀔 때(0→1분, 1→2분…) 애니메이션/카운트 처리
  private func handleMinuteChange(intent: StopWatchIntent, elapsed: TimeInterval) {
    let minuteIndex = Int(elapsed / 60.0)
    guard minuteIndex != intent.state.previousMinuteIndex else { return }

    // 분 인덱스 업데이트
    apply(intent, .setPreviousMinuteIndex(minuteIndex))

    // 현재 초 기준 progress 계산 (0 ~ 1, 최소 0.001)
    let seconds = elapsed.truncatingRemainder(dividingBy: 60)
    let progress = max(CGFloat(seconds / 60.0), 0.001)

    apply(intent, .setResetAnimationTrimAmount(progress))
    apply(intent, .incrementMinuteWrapCount)

    // 1초 뒤에 trimAmount 0으로 리셋
    Task { @MainActor [weak intent] in
      try? await Task.sleep(for: .seconds(1))
      guard let intent else { return }
      intent.state = intent.reduce(intent.state, .setResetAnimationTrimAmount(0))
    }
  }
}
