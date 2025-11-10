import SwiftUI
import Presentation
import Shared

#if canImport(ActivityKit)
import ActivityKit
#endif

@main
struct WakeyAlarmApp: App {

  var body: some Scene {
    WindowGroup {
//      AlarmView()
      StopWatchView(widgetActivityDelegateProvider: {
        return WidgetActivityManager.shared
      })
      .onAppear {
        setupWidgetIntegration()
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
        // 앱 종료 시 정리
        Task {
          await WidgetActivityManager.shared.cleanup()
        }
      }
    }
  }

  // MARK: - Private Methods

  /// Widget 통합 설정
  private func setupWidgetIntegration() {
    print("🏝️ WakeyAlarm App 시작 - Widget Extension 연결됨")

    if #available(iOS 16.1, *) {
      let manager = WidgetActivityManager.shared
      print("✅ Live Activity 지원: \(manager.activityAuthorizationStatus)")
      print("📱 활성 Activity 수: \(manager.activeActivityCount)")

      // 상세 진단 실행
      manager.diagnoseLiveActivityStatus()
    } else {
      print("📟 기본 Widget 모드 (iOS 16.0 이하)")
    }
  }
}
