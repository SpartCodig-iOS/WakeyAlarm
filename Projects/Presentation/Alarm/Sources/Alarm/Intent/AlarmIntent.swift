//
//  AlarmIntent.swift
//  Alarm
//
//  Created by 김민희 on 11/5/25.
//

import Foundation
import Domain
import Utill

final public class AlarmIntent: ObservableObject, BaseIntent {
  public typealias State = AlarmState
  public typealias Intent = AlarmUserIntent
  public typealias Action = AlarmAction

  @Published public private(set) var state = State()

  private let fetchAlarmsUseCase: FetchAlarmsUseCaseProtocol
  private let toggleAlarmUseCase: ToggleAlarmUseCaseProtocol
  private let deleteAlarmUseCase: DeleteAlarmUseCaseProtocol

  public init(
    fetchAlarmsUseCase: FetchAlarmsUseCaseProtocol,
    toggleAlarmUseCase: ToggleAlarmUseCaseProtocol,
    deleteAlarmUseCase: DeleteAlarmUseCaseProtocol
  ) {
    self.fetchAlarmsUseCase = fetchAlarmsUseCase
    self.toggleAlarmUseCase = toggleAlarmUseCase
    self.deleteAlarmUseCase = deleteAlarmUseCase
  }

  public func intent(_ userIntent: Intent) {
    switch userIntent {
    case .loadAlarms:
      Task {
        do {
          let alarms = try fetchAlarmsUseCase.execute()
          await MainActor.run {
            state = reduce(state, .alarmsLoaded(alarms))
          }
        } catch {
          print("Failed to fetch alarms: \(error)")
        }
      }

    case .toggleAlarm(let id):
      Task {
        do {
          try toggleAlarmUseCase.execute(id: id)
          await MainActor.run {
            state = reduce(state, .alarmToggled(id))
          }
        } catch {
          print("Toggle failed: \(error)")
        }
      }

    case .deleteAlarm(let alarm):
      Task {
        do {
          try deleteAlarmUseCase.execute(alarm: alarm)
          await MainActor.run {
            state = reduce(state, .alarmDeleted(alarm.id))
          }
        } catch {
          print("Delete failed: \(error)")
        }
      }

    case .addAlarm(let alarm):
      Task { @MainActor in
        state = reduce(state, .alarmAdded(alarm))
      }
    }
  }

  public func reduce(_ state: State, _ action: Action) -> State {
    var newState = state
    switch action {
    case .alarmsLoaded(let alarms):
      newState.alarms = alarms
    case .alarmToggled(let id):
      if let index = newState.alarms.firstIndex(where: { $0.id == id }) {
        newState.alarms[index].isEnabled.toggle()
      }
    case .alarmDeleted(let id):
      newState.alarms.removeAll { $0.id == id }
    case .alarmAdded(let alarm):
      newState.alarms.append(alarm)
    }
    return newState
  }
}
