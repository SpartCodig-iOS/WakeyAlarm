//
//  TimerState.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import Foundation

// MARK: - Timer State (UI 상태)
public struct TimerState: Equatable {
    // Picker 선택 값
    public var selectedHours: Int
    public var selectedMinutes: Int
    public var selectedSeconds: Int

    // 타이머 상태
    public var timerStatus: TimerStatus
    public var remainingTime: TimeInterval
    public var totalTime: TimeInterval
    public var progress: Double

    public init(
        selectedHours: Int = 0,
        selectedMinutes: Int = 0,
        selectedSeconds: Int = 0,
        timerStatus: TimerStatus = .idle,
        remainingTime: TimeInterval = 0,
        totalTime: TimeInterval = 0,
        progress: Double = 1.0
    ) {
        self.selectedHours = selectedHours
        self.selectedMinutes = selectedMinutes
        self.selectedSeconds = selectedSeconds
        self.timerStatus = timerStatus
        self.remainingTime = remainingTime
        self.totalTime = totalTime
        self.progress = progress
    }
}

// MARK: - Timer Status
public enum TimerStatus: Equatable {
    case idle       // 대기 중
    case running    // 실행 중
    case paused     // 일시정지
}

// MARK: - Computed Properties
public extension TimerState {
    var isIdle: Bool {
        timerStatus == .idle
    }

    var isRunning: Bool {
        timerStatus == .running
    }

    var isPaused: Bool {
        timerStatus == .paused
    }

    var canStart: Bool {
        isIdle && (selectedHours > 0 || selectedMinutes > 0 || selectedSeconds > 0)
    }

    var formattedRemainingTime: String {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
