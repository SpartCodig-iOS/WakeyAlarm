//
//  DIContainer.swift
//  WakeyAlarm
//
//  Created by 김민희 on 11/10/25.
//

import Swinject
import Domain
import Data

public typealias SharedContainer = Swinject.Container

@MainActor
public final class DIContainer {
  public static let shared = DIContainer()
  public let container = Container()

  private init() {
    registerBaseDependencies()
  }

  private func registerBaseDependencies() {
    // Repository
    container.register(AlarmRepositoryProtocol.self) { _ in
      AlarmRepository()
    }
    // Service
    container.register(AlarmScheduler.self) { _ in
      AlarmScheduler()
    }.inObjectScope(.container)

    // UseCase
    container.register(FetchAlarmsUseCaseProtocol.self) { r in
      guard let repo = r.resolve(AlarmRepositoryProtocol.self) else {
        fatalError("Missing AlarmRepositoryProtocol")
      }
      return FetchAlarmsUseCase(repository: repo)
    }

    container.register(ToggleAlarmUseCaseProtocol.self) { r in
      guard let repo = r.resolve(AlarmRepositoryProtocol.self), let scheduler = r.resolve(AlarmScheduler.self) else {
        fatalError("Missing AlarmRepositoryProtocol")
      }
      return ToggleAlarmUseCase(repository: repo, scheduler: scheduler)
    }

    container.register(DeleteAlarmUseCaseProtocol.self) { r in
      guard let repo = r.resolve(AlarmRepositoryProtocol.self), let scheduler = r.resolve(AlarmScheduler.self) else {
        fatalError("Missing AlarmRepositoryProtocol")
      }
      return DeleteAlarmUseCase(repository: repo, scheduler: scheduler)
    }

    container.register(AddAlarmUseCaseProtocol.self) { r in
      guard let repo = r.resolve(AlarmRepositoryProtocol.self), let scheduler = r.resolve(AlarmScheduler.self) else {
        fatalError("Missing AlarmRepositoryProtocol")
      }
      return AddAlarmUseCase(repository: repo, scheduler: scheduler)
    }

    print("✅ Base dependencies registered in DIContainer")
  }
}
