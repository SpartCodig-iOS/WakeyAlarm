//
//  TimerContainer.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import Foundation
import Combine

// MARK: - Timer Container (ViewModel)
public final class TimerContainer: ObservableObject {
    // MARK: - Published State
    @Published public private(set) var state: TimerState

    // MARK: - Private Properties
    private let model: TimerModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?

    // MARK: - Initialization
    public init(
        model: TimerModelProtocol = TimerModel(),
        initialState: TimerState = TimerState()
    ) {
        self.model = model
        self.state = initialState
    }

    // MARK: - Intent Processing
    public func send(_ intent: TimerIntent) {
        let (newState, sideEffect) = model.reduce(state: state, intent: intent)
        state = newState

        if let sideEffect = sideEffect {
            handleSideEffect(sideEffect)
        }
    }

    // MARK: - Side Effect Handling
    private func handleSideEffect(_ sideEffect: TimerSideEffect) {
        switch sideEffect {
        case .startTimerTicking:
            startTimer()

        case .stopTimerTicking:
            stopTimer()

        case .playAlarm:
            playAlarm()

        case .showCompletionAlert:
            showCompletionAlert()
        }
    }

    // MARK: - Timer Management
    private func startTimer() {
        stopTimer() // 기존 타이머 정리

        // 애니메이션과 동기화를 위해 0.3초 지연
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3초

            self.timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }

                    if self.state.remainingTime > 0 {
                        self.send(.timerTick)
                    } else {
                        self.send(.timerCompleted)
                    }
                }
        }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    // MARK: - Alarm & Notifications
    private func playAlarm() {
        // TODO: 알람 사운드 재생
        print("🔔 타이머 완료! 알람 울림")
    }

    private func showCompletionAlert() {
        // TODO: 완료 알림 표시
        print("✅ 타이머 완료 알림")
    }

    // MARK: - Cleanup
    deinit {
        stopTimer()
    }
}
