//
//  AlarmDIContainer.swift
//  Alarm
//
//  Created by 김민희 on 11/10/25.
//

import Shared

@MainActor
public struct AlarmDIContainer {
  public static func register() {
    let container = DIContainer.shared.container

    container.register(AlarmIntent.self) { r in
      guard
        let fetch = r.resolve(FetchAlarmsUseCaseProtocol.self),
        let toggle = r.resolve(ToggleAlarmUseCaseProtocol.self),
        let delete = r.resolve(DeleteAlarmUseCaseProtocol.self)
      else {
        fatalError("❌ Missing dependencies for AlarmIntent")
      }

      return AlarmIntent(
        fetchAlarmsUseCase: fetch,
        toggleAlarmUseCase: toggle,
        deleteAlarmUseCase: delete
      )
    }

    container.register(AddAlarmIntent.self) { r in
      guard let add = r.resolve(AddAlarmUseCaseProtocol.self) else {
        fatalError("❌ Missing dependencies for AddAlarmIntent")
      }
      return AddAlarmIntent(addAlarmUseCase: add)
    }
  }
}
