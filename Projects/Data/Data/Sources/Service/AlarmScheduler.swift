//
//  AlarmScheduler.swift
//  Data
//
//  Created by 김민희 on 11/10/25.
//

import Foundation
import UserNotifications
import Domain 

public final class AlarmScheduler: AlarmSchedulerProtocol {
  private let notificationCenter = UNUserNotificationCenter.current()

  public init() {}

  public func schedule(alarm: Alarm) {
    alarm.repeatDays.forEach { weekday in
      var dateComponents = DateComponents()
      dateComponents.weekday = weekday.calendarValue

      let calendar = Calendar.current
      let time = calendar.dateComponents([.hour, .minute], from: alarm.time)
      dateComponents.hour = time.hour
      dateComponents.minute = time.minute

      let content = UNMutableNotificationContent()
      content.title = "⏰ \(alarm.title)"
      content.body = "WakeyAlarm에서 설정한 알람입니다"
      content.sound = alarm.soundTitle.map {
        UNNotificationSound(named: UNNotificationSoundName($0))
      } ?? .default

      if let soundName = alarm.soundTitle, !soundName.isEmpty {
        content.sound = UNNotificationSound(named: UNNotificationSoundName("\(soundName).caf"))
      } else {
        content.sound = .default
      }


      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
      let request = UNNotificationRequest(
        identifier: "\(alarm.id)_\(weekday)",
        content: content,
        trigger: trigger
      )

      notificationCenter.add(request) { error in
        if let error = error {
          print("❌ 알람 예약 실패: \(error.localizedDescription)")
        } else {
          print("✅ 알람 예약 완료: \(request.identifier)")
        }
      }
    }
  }
  
  public func cancel(alarm: Alarm) {
    let identifiers = alarm.repeatDays.map { "\(alarm.id.uuidString)_\($0.rawValue)" }
    notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
  }
}
