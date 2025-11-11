//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by 홍석현 on 11/11/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Timer
import DesignSystem

public struct TimerLiveActivity: Widget {

    public init() {}

    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { (context: ActivityViewContext<TimerActivityAttributes>) in
            lockScreenView(context: context)
        } dynamicIsland: { (context: ActivityViewContext<TimerActivityAttributes>) in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(.blue)

                        Text("타이머")
                            .font(.pretendardFont(family: .medium, size: 14))
                            .foregroundStyle(.whiteSmoke)
                    }
                    .padding(.leading, 10)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text(formatTime(context.state.remainingTime))
                            .font(.pretendardFont(family: .bold, size: 18))
                            .foregroundStyle(.whiteSmoke)
                            .monospacedDigit()

                        Text("남은 시간")
                            .font(.pretendardFont(family: .medium, size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 10)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("전체 시간")
                                .font(.pretendardFont(family: .medium, size: 12))
                                .foregroundColor(.secondary)

                            Text(formatTime(context.state.totalTime))
                                .font(.pretendardFont(family: .medium, size: 14))
                                .monospacedDigit()
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            Circle()
                                .fill(context.state.isRunning && !context.state.isPaused ? .green : .gray)
                                .frame(width: 8, height: 8)

                            Text(context.state.isRunning && !context.state.isPaused ? "실행 중" : "정지됨")
                                .font(.pretendardFont(family: .medium, size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .foregroundColor(.blue)
                    .padding(.leading, 10)
            } compactTrailing: {
                Text(formatTime(context.state.remainingTime))
                    .font(.pretendardFont(family: .medium, size: 12))
                    .monospacedDigit()
                    .padding(.trailing, 10)
            } minimal: {
                Image(systemName: context.state.isRunning && !context.state.isPaused ? "play.fill" : "pause.fill")
                    .foregroundColor(context.state.isRunning && !context.state.isPaused ? .green : .orange)
            }
        }
    }

    @ViewBuilder
    private func lockScreenView(
        context: ActivityViewContext<TimerActivityAttributes>
    ) -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.blue)

                Text("타이머")
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()

                Text(context.state.isRunning && !context.state.isPaused ? "실행 중" : "정지됨")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(context.state.isRunning && !context.state.isPaused ? .green.opacity(0.2) : .gray.opacity(0.2))
                    )
                    .foregroundColor(context.state.isRunning && !context.state.isPaused ? .green : .secondary)
            }

            VStack(spacing: 4) {
                Text(formatTime(context.state.remainingTime))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)

                Text("남은 시간")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            HStack {
                Text("전체 시간")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatTime(context.state.totalTime))
                    .font(.caption)
                    .fontWeight(.medium)
                    .monospacedDigit()
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

@available(iOS 17.0, *)
#Preview(
    "타이머 잠금 화면",
    as: .content,
    using: TimerActivityAttributes.preview
) {
    TimerLiveActivity()
} contentStates: {
    TimerActivityAttributes.ContentState.sample
    TimerActivityAttributes.ContentState.almostDone
}
