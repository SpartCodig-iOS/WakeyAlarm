import SwiftUI
import Alarm
import Shared

@main
struct WakeyAlarmApp: App {
  init() {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    _ = DIContainer.shared
    AlarmDIContainer.register()
  }
    var body: some Scene {
        WindowGroup {
          AlarmView()
        }
    }
}
