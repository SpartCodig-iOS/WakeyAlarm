//
//  TimerNotificationService.swift
//  Timer
//
//  Created by 홍석현 on 11/11/25.
//

import Foundation
import UserNotifications

public protocol TimerNotificationServiceProtocol {
    func requestAuthorization() async -> Bool
    func scheduleNotification(endDate: Date, totalTime: TimeInterval)
    func cancelNotification()
}

public final class TimerNotificationService: TimerNotificationServiceProtocol {
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationIdentifier = "com.wakeyalarm.timer.completion"

    public init() {}

    // MARK: - Authorization
    public func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("✅ 타이머 알림 권한 허용됨")
            } else {
                print("🚫 타이머 알림 권한 거부됨")
            }
            return granted
        } catch {
            print("❌ 타이머 알림 권한 요청 실패: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Schedule
    public func scheduleNotification(endDate: Date, totalTime: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ 타이머 완료"
        content.body = formatTimeForMessage(totalTime) + " 타이머가 완료되었습니다"
        content.sound = .default
        content.categoryIdentifier = "TIMER_COMPLETION"

        let timeInterval = endDate.timeIntervalSinceNow

        // 최소 1초 이상이어야 알림이 예약됨
        guard timeInterval > 1 else {
            print("⚠️ 타이머 종료 시간이 너무 짧아 알림을 예약할 수 없습니다")
            return
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("❌ 타이머 알림 예약 실패: \(error.localizedDescription)")
            } else {
                print("✅ 타이머 알림 예약 완료: \(self.formatTimeForMessage(totalTime))")
            }
        }
    }

    // MARK: - Cancel
    public func cancelNotification() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
        print("🗑️ 타이머 알림 취소됨")
    }

    // MARK: - Helper
    private func formatTimeForMessage(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60

        if hours > 0 {
            return String(format: "%d시간 %d분 %d초", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%d분 %d초", minutes, seconds)
        } else {
            return String(format: "%d초", seconds)
        }
    }
}
