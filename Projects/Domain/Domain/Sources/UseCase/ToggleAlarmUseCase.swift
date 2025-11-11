//
//  ToggleAlarmUseCase.swift
//  Domain
//
//  Created by 김민희 on 11/6/25.
//

import Foundation

public protocol ToggleAlarmUseCaseProtocol {
  func execute(id: UUID) throws
}

public final class ToggleAlarmUseCase: ToggleAlarmUseCaseProtocol {
  private let repository: AlarmRepositoryProtocol
  private let scheduler: AlarmSchedulerProtocol

  public init(repository: AlarmRepositoryProtocol, scheduler: AlarmSchedulerProtocol) {
    self.repository = repository
    self.scheduler = scheduler
  }

  public func execute(id: UUID) throws {
    try repository.toggleAlarm(id: id)
    guard let alarm = try repository.fetchAlarms().first(where: { $0.id == id }) else { return }

    if alarm.isEnabled {
      scheduler.schedule(alarm: alarm)
    } else {
      scheduler.cancel(alarm: alarm)
    }
  }
}
