//
//  DeleteAlarmUseCase.swift
//  Domain
//
//  Created by 김민희 on 11/6/25.
//

import Foundation

public protocol DeleteAlarmUseCaseProtocol {
  func execute(alarm: Alarm) throws
}

public final class DeleteAlarmUseCase: DeleteAlarmUseCaseProtocol {
  private let repository: AlarmRepositoryProtocol
  private let scheduler: AlarmSchedulerProtocol

  public init(repository: AlarmRepositoryProtocol, scheduler: AlarmSchedulerProtocol) {
    self.repository = repository
    self.scheduler = scheduler
  }

  public func execute(alarm: Alarm) throws {
    try repository.deleteAlarm(id: alarm.id)
    scheduler.cancel(alarm: alarm)
  }
}
