
import ActivityKit
import WidgetKit
import SwiftUI
import StopWatch
import DesignSystem

public struct StopWatchLiveActivity: Widget {

  public init() {}

  public var body: some WidgetConfiguration {
    ActivityConfiguration(for: StopWatchActivityAttributes.self) { (context: ActivityViewContext<StopWatchActivityAttributes>) in
      lockScreenView(context: context)
    } dynamicIsland: { (context: ActivityViewContext<StopWatchActivityAttributes>) in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          HStack {
            Image(systemName: "stopwatch")
              .foregroundColor(.orange)

            Text("스톱워치")
              .font(.pretendardFont(family: .medium, size: 14))
              .foregroundStyle(.whiteSmoke)
          }
          .padding(.leading, 10)
        }

        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .trailing) {
            Text(context.state.formattedElapsedTime)
              .font(.pretendardFont(family: .bold, size: 18))
              .foregroundStyle(.whiteSmoke)
              .monospacedDigit()

            if context.state.lapCount > 0 {
              Text("랩 \(context.state.lapCount)")
                .font(.pretendardFont(family: .medium, size: 14))
                .foregroundColor(.secondary)
            }
          }
          .padding(.trailing, 10)
        }

        DynamicIslandExpandedRegion(.bottom) {
          HStack {
            if let _ = context.state.currentLapTime {
              VStack(alignment: .leading) {
                Text("현재 랩")
                  .font(.pretendardFont(family: .medium, size: 14))
                  .foregroundColor(.secondary)

                Text(context.state.formattedCurrentLapTime)
                  .font(.pretendardFont(family: .medium, size: 14))
                  .monospacedDigit()
              }
            }

            Spacer()

            HStack(spacing: 4) {
              Circle()
                .fill(context.state.isRunning ? .green : .gray)
                .frame(width: 8, height: 8)

              Text(context.state.isRunning ? "실행 중" : "정지됨")
                .font(.pretendardFont(family: .medium, size: 14))
                .foregroundColor(.secondary)
            }
          }
          .padding(.leading, 10)
        }
      } compactLeading: {
        Image(systemName: "stopwatch")
          .foregroundColor(.orange)
          .padding(.leading, 10)

      } compactTrailing: {
        Text(context.state.formattedElapsedTime)
          .font(.pretendardFont(family: .medium, size: 12))
          .monospacedDigit()
          .padding(.trailing, 10)
      } minimal: {
        Image(systemName: context.state.isRunning ? "play.fill" : "pause.fill")
          .foregroundColor(context.state.isRunning ? .green : .orange)
      }
    }
  }

  @ViewBuilder
  private func lockScreenView(
    context: ActivityViewContext<StopWatchActivityAttributes>
  ) -> some View {
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
