import WidgetKit
import SwiftUI

// MARK: - Widget Bundle
@main
struct WakeyAlarmWidgetBundle: WidgetBundle {
    var body: some Widget {
        // iOS 16.1+ Live Activity 지원
        #if canImport(ActivityKit)
        if #available(iOS 16.1, *) {
            StopWatchLiveActivity()
        }
        #endif
    }
}
