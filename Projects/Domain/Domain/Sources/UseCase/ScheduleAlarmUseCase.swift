//
//  ScheduleAlarmUseCase.swift
//  Domain
//
//  Created by 김민희 on 11/10/25.
//

import Foundation
import UserNotifications

protocol ScheduleAlarmUseCase {
  func schedule(alarm: Alarm)
}

final class ScheduleAlarmUseCaseImpl: ScheduleAlarmUseCase {
  private let notificationCenter = UNUserNotificationCenter.current()

  func schedule(alarm: Alarm) {
    alarm.repeatDays.forEach { weekday in
      var dateComponents = DateComponents()
      dateComponents.weekday = weekday.calendarValue

      let calendar = Calendar.current
      let components = calendar.dateComponents([.hour, .minute], from: alarm.time)
      dateComponents.hour = components.hour
      dateComponents.minute = components.minute

      let content = UNMutableNotificationContent()
      content.title = alarm.title
      content.body = "설정한 알람이 울립니다."
      if let soundTitle = alarm.soundTitle {
        content.sound = UNNotificationSound(named: UNNotificationSoundName(soundTitle))
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
          print("❌ 알람 등록 실패: \(error.localizedDescription)")
        } else {
          print("✅ 알람 등록 완료: \(request.identifier)")
        }
      }
    }
  }
}
