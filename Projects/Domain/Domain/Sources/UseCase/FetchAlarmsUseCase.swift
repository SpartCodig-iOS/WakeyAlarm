//
//  FetchAlarmsUseCase.swift
//  Domain
//
//  Created by 김민희 on 11/6/25.
//

public protocol FetchAlarmsUseCaseProtocol {
  func execute() throws -> [Alarm]
}

public final class FetchAlarmsUseCase: FetchAlarmsUseCaseProtocol {
  private let repository: AlarmRepositoryProtocol
  public init(repository: AlarmRepositoryProtocol) {
    self.repository = repository
  }

  public func execute() throws -> [Alarm] {
    try repository.fetchAlarms()
  }
}
