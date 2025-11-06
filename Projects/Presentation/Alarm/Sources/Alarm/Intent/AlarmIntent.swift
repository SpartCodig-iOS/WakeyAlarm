//
//  AlarmIntent.swift
//  Alarm
//
//  Created by 김민희 on 11/5/25.
//

import Foundation
import Domain
import Utill

@MainActor
final class AlarmIntent: ObservableObject, BaseIntent {
  typealias State = AlarmState
  typealias Intent = AlarmUserIntent
  typealias Action = AlarmAction

  @Published private(set) var state = State()

  func intent(_ userIntent: Intent) {
    switch userIntent {
    case .loadAlarms:
      // TODO: 나중에 CoreData fetch 로직 추가
      break

    case .toggleAlarm(let id):
      state = reduce(state, .alarmToggled(id))

    case .deleteAlarm(let id):
      state = reduce(state, .alarmDeleted(id))

    case .addAlarm(let alarm):
      state = reduce(state, .alarmAdded(alarm))
    }
  }

  func reduce(_ state: State, _ action: Action) -> State {
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
