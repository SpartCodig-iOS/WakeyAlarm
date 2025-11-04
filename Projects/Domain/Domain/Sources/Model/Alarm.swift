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

  public init(id: UUID, title: String, time: Date, isEnabled: Bool, repeatDays: [Weekday]) {
    self.id = id
    self.title = title
    self.time = time
    self.isEnabled = isEnabled
    self.repeatDays = repeatDays
  }

  public var formattedTime: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: time)
  }
}
