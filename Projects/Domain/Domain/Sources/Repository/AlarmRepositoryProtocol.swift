//
//  AlarmRepositoryProtocol.swift
//  Domain
//
//  Created by 김민희 on 11/6/25.
//

import Foundation

public protocol AlarmRepositoryProtocol {
  func fetchAlarms() throws -> [Alarm]
  func addAlarm(_ alarm: Alarm) throws
  func toggleAlarm(id: UUID) throws
  func deleteAlarm(id: UUID) throws
}
