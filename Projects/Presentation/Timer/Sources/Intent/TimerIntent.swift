//
//  TimerIntent.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import Foundation

// MARK: - Timer Intent (사용자 액션)
public enum TimerIntent {
    case selectHours(Int)
    case selectMinutes(Int)
    case selectSeconds(Int)
    case startTimer
    case pauseTimer
    case resumeTimer
    case cancelTimer
    case timerTick
    case timerCompleted
}
