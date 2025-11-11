//
//  AlarmUserIntent.swift
//  Alarm
//
//  Created by 김민희 on 11/6/25.
//


import Foundation
import Shared

public enum AlarmUserIntent {
  case loadAlarms
  case toggleAlarm(UUID)
  case deleteAlarm(Alarm)
  case addAlarm(Alarm)
}
