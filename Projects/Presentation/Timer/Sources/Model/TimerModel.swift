//
//  TimerModel.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import Foundation
import Combine

// MARK: - Timer Model (비즈니스 로직)
public protocol TimerModelProtocol {
    func reduce(state: TimerState, intent: TimerIntent) -> (TimerState, TimerSideEffect?)
}

public final class TimerModel: TimerModelProtocol {
    public init() {}

    public func reduce(
        state: TimerState,
        intent: TimerIntent
    ) -> (TimerState, TimerSideEffect?) {
        var newState = state
        var sideEffect: TimerSideEffect?

        switch intent {
        case .selectHours(let hours):
            newState.selectedHours = hours

        case .selectMinutes(let minutes):
            newState.selectedMinutes = minutes

        case .selectSeconds(let seconds):
            newState.selectedSeconds = seconds

        case .startTimer:
            let totalSeconds = state.selectedHours * 3600 + state.selectedMinutes * 60 + state.selectedSeconds
            newState.totalTime = TimeInterval(totalSeconds)
            newState.remainingTime = TimeInterval(totalSeconds)
            newState.progress = 1.0
            newState.timerStatus = .running
            newState.endDate = Date().addingTimeInterval(TimeInterval(totalSeconds))
            sideEffect = .startTimerTicking

        case .pauseTimer:
            newState.timerStatus = .paused
            newState.endDate = nil
            sideEffect = .stopTimerTicking

        case .resumeTimer:
            newState.timerStatus = .running
            newState.endDate = Date().addingTimeInterval(state.remainingTime)
            sideEffect = .startTimerTicking

        case .cancelTimer:
            newState.timerStatus = .idle
            newState.remainingTime = 0
            newState.progress = 1.0
            newState.endDate = nil
            sideEffect = .stopTimerTicking

        case .timerTick:
            if state.remainingTime > 0 {
                newState.remainingTime = max(0, state.remainingTime - 0.1)
                newState.progress = state.totalTime > 0 ? newState.remainingTime / state.totalTime : 0
            }

        case .updateRemainingTime(let remaining):
            newState.remainingTime = max(0, remaining)
            newState.progress = state.totalTime > 0 ? newState.remainingTime / state.totalTime : 0

        case .timerCompleted:
            newState.timerStatus = .idle
            newState.remainingTime = 0
            newState.progress = 1.0
            newState.endDate = nil
            sideEffect = .playAlarm
        }

        return (newState, sideEffect)
    }
}
