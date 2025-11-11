//
//  TimerView.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - 타이머 뷰
public struct TimerView: View {
    @StateObject private var container: TimerContainer

    public init(container: TimerContainer = TimerContainer()) {
        _container = StateObject(wrappedValue: container)
    }

    public var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // 원형 진행 표시
                CircularProgressView(
                    progress: container.state.progress,
                    remainingTime: container.state.formattedRemainingTime,
                    isPaused: container.state.isPaused,
                    isIdle: container.state.isIdle
                )

                // 대기 상태일 때는 피커를 원 위에 표시
                if container.state.isIdle {
                    TimePickerView(
                        selectedHours: Binding(
                            get: { container.state.selectedHours },
                            set: { container.send(.selectHours($0)) }
                        ),
                        selectedMinutes: Binding(
                            get: { container.state.selectedMinutes },
                            set: { container.send(.selectMinutes($0)) }
                        ),
                        selectedSeconds: Binding(
                            get: { container.state.selectedSeconds },
                            set: { container.send(.selectSeconds($0)) }
                        )
                    )
                    .transition(.opacity)
                }
            }

            // 컨트롤 버튼
            TimerControlButtons(
                isIdle: container.state.isIdle,
                isRunning: container.state.isRunning,
                canStart: container.state.canStart,
                onStart: { container.send(.startTimer) },
                onCancel: { container.send(.cancelTimer) },
                onPause: { container.send(.pauseTimer) },
                onResume: { container.send(.resumeTimer) }
            )
            .padding(.bottom, 60)
        }
        .animation(.easeInOut(duration: 0.3), value: container.state.timerStatus)
    }
}

// MARK: - 프리뷰
#Preview {
    TimerView()
}
