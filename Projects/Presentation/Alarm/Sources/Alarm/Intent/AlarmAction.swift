//
//  AlarmAction.swift
//  Alarm
//
//  Created by 김민희 on 11/5/25.
//

import Foundation
import Domain

enum AlarmAction {
  case alarmsLoaded([Alarm])
  case alarmToggled(UUID)
  case alarmDeleted(UUID)
  case alarmAdded(Alarm)
}

