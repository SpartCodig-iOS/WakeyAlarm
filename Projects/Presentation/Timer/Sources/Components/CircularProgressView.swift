//
//  CircularProgressView.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import SwiftUI

// MARK: - 원형 진행 표시 컴포넌트
struct CircularProgressView: View {
    let progress: Double
    let remainingTime: String
    let isPaused: Bool
    let isIdle: Bool

    var body: some View {
        ZStack {
            // 배경 원
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                .frame(width: 280, height: 280)

            // 진행 원
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.orange,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(90))
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .animation(.linear(duration: 0.1), value: progress)

            // 시간 표시 (실행 중일 때만)
            if !isIdle {
                VStack(spacing: 8) {
                    Text(remainingTime)
                        .font(.system(size: 72, weight: .thin, design: .default))
                        .foregroundColor(.black)
                        .monospacedDigit()

                    if isPaused {
                        Text("일시정지")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
}
