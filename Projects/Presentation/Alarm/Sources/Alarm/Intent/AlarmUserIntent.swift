//
//  AlarmUserIntent.swift
//  Alarm
//
//  Created by 김민희 on 11/6/25.
//


import Foundation
import Domain

enum AlarmUserIntent {
  case loadAlarms
  case toggleAlarm(UUID)
  case deleteAlarm(UUID)
  case addAlarm(Alarm)
}
