//
//  Alarm.swift
//  Domain
//
//  Created by 김민희 on 11/4/25.
//

import Foundation

public struct Alarm {
  public var id: UUID = UUID()
  public var title: String
  public var time: Date
  public var isEnabled: Bool
  public var repeatDays: [Weekday]
  public var soundTitle: String?

  public init(id: UUID, title: String, time: Date, isEnabled: Bool = true, repeatDays: [Weekday], soundTitle: String? = nil) {
    self.id = id
    self.title = title
    self.time = time
    self.isEnabled = isEnabled
    self.repeatDays = repeatDays
    self.soundTitle = soundTitle
  }

  public var formattedTime: (String, String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let full = formatter.string(from: time)
    let parts = full.split(separator: " ")
    if parts.count == 2 {
      return (String(parts[0]), String(parts[1]))
    } else {
      return (full, "")
    }
  }
}
