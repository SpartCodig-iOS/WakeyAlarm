//
//  AlarmSchedulerProtocol.swift
//  Domain
//
//  Created by 김민희 on 11/10/25.
//

import Foundation

public protocol AlarmSchedulerProtocol {
  func schedule(alarm: Alarm)
  func cancel(alarm: Alarm)
}
