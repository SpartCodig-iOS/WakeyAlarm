//
//  AddAlarmUserIntent.swift
//  Alarm
//
//  Created by 김민희 on 11/6/25.
//


import Foundation
import Shared

public enum AddAlarmUserIntent {
  case setTime(Date)
  case setTitle(String)
  case setRepeatDays(Set<Weekday>)
  case setSound(String)
  case addAlarm
}
