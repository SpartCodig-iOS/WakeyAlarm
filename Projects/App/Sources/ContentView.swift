import SwiftUI
import Alarm
import StopWatch
import Timer

public struct ContentView: View {
    public init() {}

    public var body: some View {
        TabView {
            AlarmView()
                .tabItem {
                    Label("알람", systemImage: "alarm.fill")
                }

            StopWatchView()
                .tabItem {
                    Label("스톱워치", systemImage: "stopwatch.fill")
                }

            TimerView()
                .tabItem {
                    Label("타이머", systemImage: "timer")
                }
        }
    }
}

#Preview {
    ContentView()
}
