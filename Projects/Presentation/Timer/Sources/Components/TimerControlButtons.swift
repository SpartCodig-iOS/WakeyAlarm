//
//  TimerControlButtons.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import SwiftUI
import DesignSystem

// MARK: - 타이머 컨트롤 버튼 컴포넌트
struct TimerControlButtons: View {
    let isIdle: Bool
    let isRunning: Bool
    let canStart: Bool
    let onStart: () -> Void
    let onCancel: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void

    var body: some View {
        HStack(spacing: 60) {
            if isIdle {
                // 시작 버튼
                Button(action: onStart) {
                    ZStack {
                        Circle()
                            .fill(Color.mintGreen)
                            .frame(width: 80, height: 80)

                        Text("시작")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(!canStart)
                .opacity(canStart ? 1.0 : 0.3)
            } else {
                // 취소 버튼
                Button(action: onCancel) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 80, height: 80)

                        Text("취소")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.black)
                    }
                }

                // 일시정지/재개 버튼
                Button(action: {
                    if isRunning {
                        onPause()
                    } else {
                        onResume()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 80, height: 80)

                        Text(isRunning ? "일시정지" : "재개")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
