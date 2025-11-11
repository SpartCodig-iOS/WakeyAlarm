import WidgetKit
import SwiftUI

// MARK: - Widget Bundle
@main
struct WakeyAlarmWidgetBundle: WidgetBundle {
    var body: some Widget {
        StopWatchLiveActivity()
        TimerLiveActivity()
    }
}
