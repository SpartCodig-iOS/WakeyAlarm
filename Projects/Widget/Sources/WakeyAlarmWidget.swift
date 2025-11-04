import WidgetKit
import SwiftUI

// MARK: - Simple Widget Entry (iOS 16.6 호환)
struct SimpleEntry: TimelineEntry {
    let date: Date
}

// MARK: - Timeline Provider (iOS 16.6 호환)
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entries: [SimpleEntry] = [
            SimpleEntry(date: Date())
        ]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - Widget Entry View
struct WakeyAlarmWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "stopwatch")
                .font(.title2)
                .foregroundColor(.orange)

            Text("스톱워치")
                .font(.caption)
                .fontWeight(.medium)

            Text("00:00.00")
                .font(.caption2)
                .fontWeight(.bold)
                .monospacedDigit()
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}

// MARK: - Widget Configuration (iOS 16.6 호환)
struct WakeyAlarmWidget: Widget {
    let kind: String = "WakeyAlarmWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WakeyAlarmWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WakeyAlarm")
        .description("스톱워치 위젯")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Widget Bundle
@main
struct WakeyAlarmWidgetBundle: WidgetBundle {
    var body: some Widget {
        WakeyAlarmWidget()

        // iOS 16.1+ Live Activity 지원
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
            StopWatchLiveActivity()
        }
        #endif
    }
}

// MARK: - Preview (iOS 16.6 호환)
#if DEBUG
struct WakeyAlarmWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WakeyAlarmWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small Widget")

            WakeyAlarmWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium Widget")
        }
    }
}
#endif
