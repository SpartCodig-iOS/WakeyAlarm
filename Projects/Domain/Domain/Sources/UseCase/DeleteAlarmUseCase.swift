//
//  DeleteAlarmUseCase.swift
//  Domain
//
//  Created by 김민희 on 11/6/25.
//

import Foundation

public protocol DeleteAlarmUseCaseProtocol {
  func execute(id: UUID) throws
}

public final class DeleteAlarmUseCase: DeleteAlarmUseCaseProtocol {
  private let repository: AlarmRepositoryProtocol

  public init(repository: AlarmRepositoryProtocol) {
    self.repository = repository
  }

  public func execute(id: UUID) throws {
    try repository.deleteAlarm(id: id)
  }
}
