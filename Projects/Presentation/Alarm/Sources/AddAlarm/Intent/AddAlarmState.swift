//
//  AddAlarmState.swift
//  Alarm
//
//  Created by 김민희 on 11/6/25.
//


import Foundation
import Domain

public struct AddAlarmState {
  var alarms: [Alarm] = []
  var title: String = ""
  var time: Date = Date()
  var repeatDays: Set<Weekday> = []
  var soundTitle: String = ""
}
