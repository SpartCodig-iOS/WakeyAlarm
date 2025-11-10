//
//  AddAlarmUseCaseProtocol.swift
//  Domain
//
//  Created by 김민희 on 11/7/25.
//


public protocol AddAlarmUseCaseProtocol {
  func execute(_ alarm: Alarm) throws
}

public final class AddAlarmUseCase: AddAlarmUseCaseProtocol {
  private let repository: AlarmRepositoryProtocol

  public init(repository: AlarmRepositoryProtocol) {
    self.repository = repository
  }

  public func execute(_ alarm: Alarm) throws {
    try repository.addAlarm(alarm)
  }
}
