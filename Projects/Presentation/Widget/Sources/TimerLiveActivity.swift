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
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            TimerLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    TimerExpandedLeadingView()
                }

                DynamicIslandExpandedRegion(.trailing) {
                    TimerExpandedTrailingView(context: context)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    TimerExpandedBottomView(context: context)
                }
            } compactLeading: {
                TimerCompactLeadingView()
            } compactTrailing: {
                TimerCompactTrailingView(remainingTime: context.state.remainingTime)
            } minimal: {
                TimerMinimalView(isActive: context.state.isRunning && !context.state.isPaused)
            }
        }
    }
}

// MARK: - Lock Screen Components

private struct TimerLockScreenView: View {
    let context: ActivityViewContext<TimerActivityAttributes>

    var body: some View {
        VStack(spacing: 12) {
            TimerHeaderView(isActive: context.state.isRunning && !context.state.isPaused)
            TimerMainTimeView(remainingTime: context.state.remainingTime)
            Divider()
            TimerTotalTimeRow(totalTime: context.state.totalTime)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

private struct TimerHeaderView: View {
    let isActive: Bool

    var body: some View {
        HStack {
            Image(systemName: "timer")
                .foregroundColor(.blue)

            Text("타이머")
                .font(.headline)
                .fontWeight(.medium)

            Spacer()

            StatusBadge(isActive: isActive)
        }
    }
}

private struct StatusBadge: View {
    let isActive: Bool

    var body: some View {
        Text(isActive ? "실행 중" : "정지됨")
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(isActive ? .green.opacity(0.2) : .gray.opacity(0.2))
            )
            .foregroundColor(isActive ? .green : .secondary)
    }
}

private struct TimerMainTimeView: View {
    let remainingTime: TimeInterval

    var body: some View {
        VStack(spacing: 4) {
            Text(formatTime(remainingTime))
                .font(.system(size: 32, weight: .bold, design: .monospaced))
                .foregroundColor(.primary)

            Text("남은 시간")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

private struct TimerTotalTimeRow: View {
    let totalTime: TimeInterval

    var body: some View {
        HStack {
            Text("전체 시간")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(formatTime(totalTime))
                .font(.caption)
                .fontWeight(.medium)
                .monospacedDigit()
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Dynamic Island Components

private struct TimerExpandedLeadingView: View {
    var body: some View {
        HStack {
            Image(systemName: "timer")
                .foregroundColor(.blue)

            Text("타이머")
                .font(.pretendardFont(family: .medium, size: 14))
                .foregroundStyle(.whiteSmoke)
        }
        .padding(.leading, 10)
    }
}

private struct TimerExpandedTrailingView: View {
    let context: ActivityViewContext<TimerActivityAttributes>

    var body: some View {
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
}

private struct TimerExpandedBottomView: View {
    let context: ActivityViewContext<TimerActivityAttributes>

    var body: some View {
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

            StatusIndicator(isActive: context.state.isRunning && !context.state.isPaused)
        }
        .padding(.horizontal, 10)
    }
}

private struct StatusIndicator: View {
    let isActive: Bool

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isActive ? .green : .gray)
                .frame(width: 8, height: 8)

            Text(isActive ? "실행 중" : "정지됨")
                .font(.pretendardFont(family: .medium, size: 12))
                .foregroundColor(.secondary)
        }
    }
}

private struct TimerCompactLeadingView: View {
    var body: some View {
        Image(systemName: "timer")
            .foregroundColor(.blue)
            .padding(.leading, 10)
    }
}

private struct TimerCompactTrailingView: View {
    let remainingTime: TimeInterval

    var body: some View {
        Text(formatTime(remainingTime))
            .font(.pretendardFont(family: .medium, size: 12))
            .monospacedDigit()
            .padding(.trailing, 10)
    }
}

private struct TimerMinimalView: View {
    let isActive: Bool

    var body: some View {
        Image(systemName: isActive ? "play.fill" : "pause.fill")
            .foregroundColor(isActive ? .green : .orange)
    }
}

// MARK: - Helper Functions

private func formatTime(_ timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d:%02d", minutes, seconds)
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
