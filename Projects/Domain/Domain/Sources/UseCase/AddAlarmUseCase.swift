//
//  AddAlarmUseCase.swift
//  Domain
//
//  Created by 김민희 on 11/7/25.
//


public protocol AddAlarmUseCaseProtocol {
  func execute(_ alarm: Alarm) throws
}

public final class AddAlarmUseCase: AddAlarmUseCaseProtocol {
  private let repository: AlarmRepositoryProtocol
  private let scheduler: AlarmSchedulerProtocol

  public init(repository: AlarmRepositoryProtocol, scheduler: AlarmSchedulerProtocol) {
    self.repository = repository
    self.scheduler = scheduler
  }

  public func execute(_ alarm: Alarm) throws {
    try repository.addAlarm(alarm)
    scheduler.schedule(alarm: alarm)
  }
}
