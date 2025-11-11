//
//  AppDelegate.swift
//  WakeyAlarm
//
//  Created by 김민희 on 11/11/25.
//

import UIKit
import UserNotifications


final class AppDelegate: NSObject, UIApplicationDelegate, @MainActor UNUserNotificationCenterDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    // UNUserNotificationCenter 설정
    let center = UNUserNotificationCenter.current()
    center.delegate = self

    // 권한 요청
    requestNotificationAuthorization()

    print("✅ AppDelegate 초기화 완료")
    return true
  }

  /// 알림 권한 요청
  private func requestNotificationAuthorization() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      DispatchQueue.main.async {
        if let error = error {
          print("❌ 알림 권한 요청 실패: \(error.localizedDescription)")
        } else if granted {
          print("✅ 알림 권한 허용됨")
        } else {
          print("🚫 알림 권한 거부됨")
        }
      }
    }
  }

  // MARK: - Foreground 알림 처리
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // 앱이 켜져 있어도 배너/사운드 표시
    completionHandler([.banner, .sound])
  }

  // MARK: - 알림 클릭 처리
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    print("🔔 알림 클릭됨: \(userInfo)")
    completionHandler()
  }
}
