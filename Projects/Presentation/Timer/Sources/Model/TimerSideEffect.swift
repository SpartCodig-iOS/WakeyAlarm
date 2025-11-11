//
//  TimerSideEffect.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import Foundation

// MARK: - Timer Side Effect (부수 효과)
public enum TimerSideEffect {
    case startTimerTicking      // 타이머 시작
    case stopTimerTicking       // 타이머 중지
    case playAlarm             // 알람 재생
    case showCompletionAlert   // 완료 알림 표시
}
