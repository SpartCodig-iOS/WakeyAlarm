#if canImport(ActivityKit)
@preconcurrency import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - StopWatch Live Activity Widget (iOS 16.1+)
@available(iOS 16.1, *)
struct StopWatchLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: StopWatchActivityAttributes.self) { context in
      lockScreenView(context: context)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          HStack {
            Image(systemName: "stopwatch")
              .foregroundColor(.orange)
            Text("스톱워치")
              .font(.caption)
              .fontWeight(.medium)
          }
        }

        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .trailing) {
            Text(context.state.formattedElapsedTime)
              .font(.title2)
              .fontWeight(.bold)
              .monospacedDigit()

            if context.state.lapCount > 0 {
              Text("랩 \(context.state.lapCount)")
                .font(.caption2)
                .foregroundColor(.secondary)
            }
          }
        }

        DynamicIslandExpandedRegion(.bottom) {
          HStack {
            if let _ = context.state.currentLapTime {
              VStack(alignment: .leading) {
                Text("현재 랩")
                  .font(.caption2)
                  .foregroundColor(.secondary)
                Text(context.state.formattedCurrentLapTime)
                  .font(.caption)
                  .fontWeight(.medium)
                  .monospacedDigit()
              }
            }

            Spacer()

            HStack(spacing: 4) {
              Circle()
                .fill(context.state.isRunning ? .green : .gray)
                .frame(width: 8, height: 8)
              Text(context.state.isRunning ? "실행 중" : "정지됨")
                .font(.caption2)
                .foregroundColor(.secondary)
            }
          }
          .padding(.horizontal)
        }
      } compactLeading: {
        Image(systemName: "stopwatch")
          .foregroundColor(.orange)
      } compactTrailing: {
        Text(context.state.formattedElapsedTime)
          .font(.caption2)
          .fontWeight(.medium)
          .monospacedDigit()
      } minimal: {
        Image(systemName: context.state.isRunning ? "play.fill" : "pause.fill")
          .foregroundColor(context.state.isRunning ? .green : .orange)
      }
    }
  }

  @ViewBuilder
  private func lockScreenView(context: ActivityViewContext<StopWatchActivityAttributes>) -> some View {
    VStack(spacing: 12) {
      HStack {
        Image(systemName: "stopwatch")
          .foregroundColor(.orange)
        Text(context.attributes.name)
          .font(.headline)
          .fontWeight(.medium)
        Spacer()
        Text(context.state.isRunning ? "실행 중" : "정지됨")
          .font(.caption)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(
            Capsule()
              .fill(context.state.isRunning ? .green.opacity(0.2) : .gray.opacity(0.2))
          )
          .foregroundColor(context.state.isRunning ? .green : .secondary)
      }

      VStack(spacing: 4) {
        Text(context.state.formattedElapsedTime)
          .font(.system(size: 32, weight: .bold, design: .monospaced))
          .foregroundColor(.primary)

        if context.state.lapCount > 0 {
          Text("랩 \(context.state.lapCount)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      if let _ = context.state.currentLapTime {
        Divider()

        HStack {
          Text("현재 랩")
            .font(.caption)
            .foregroundColor(.secondary)
          Spacer()
          Text(context.state.formattedCurrentLapTime)
            .font(.caption)
            .fontWeight(.medium)
            .monospacedDigit()
            .foregroundColor(.primary)
        }
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.ultraThinMaterial)
    )
  }
}

#if DEBUG
@available(iOS 16.1, *)
struct StopWatchLiveActivity_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      Text("🏝️ Dynamic Island")
        .font(.title2)
        .fontWeight(.bold)

      Text("스톱워치 Live Activity")
        .font(.title3)
        .fontWeight(.medium)

      VStack(spacing: 8) {
        Text("• Dynamic Island (iPhone 14 Pro+)")
        Text("• Lock Screen 알림")
        Text("• 실시간 스톱워치 상태")
        Text("• 랩 타임 표시")
      }
      .font(.caption)
      .foregroundColor(.secondary)

      Divider()

      Text("실제 기기나 시뮬레이터에서")
      Text("Live Activity를 확인하세요!")
        .font(.caption)
        .foregroundColor(.orange)
    }
    .padding()
    .previewDisplayName("Live Activity Info")
  }
}
#endif

#endif
