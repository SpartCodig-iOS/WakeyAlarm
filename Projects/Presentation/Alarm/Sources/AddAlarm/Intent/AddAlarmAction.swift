//
//  AddAlarmAction.swift
//  Alarm
//
//  Created by 김민희 on 11/6/25.
//


import Foundation
import Shared

public enum AddAlarmAction {
  case updateTime(Date)
  case updateTitle(String)
  case updateRepeatDays(Set<Weekday>)
  case updateSound(String)
  case alarmAdded(Alarm)
}
