//
//  AddAlarmIntent.swift
//  Alarm
//
//  Created by 김민희 on 11/6/25.
//


import Foundation
import Domain
import Utill

@MainActor
final class AddAlarmIntent: ObservableObject, BaseIntent {
  typealias State = AddAlarmState
  typealias Intent = AddAlarmUserIntent
  typealias Action = AddAlarmAction

  @Published private(set) var state = State()

  func intent(_ userIntent: Intent) {
    switch userIntent {
    case .setTime(let time):
      state = reduce(state, .updateTime(time))
    case .setTitle(let title):
      state = reduce(state, .updateTitle(title))
    case .setRepeatDays(let days):
      state = reduce(state, .updateRepeatDays(days))
    case .setSound(let sound):
      state = reduce(state, .updateSound(sound))
    case .addAlarm:
      let alarm = Alarm(
        id: UUID(),
        title: state.title.isEmpty ? "알람" : state.title,
        time: state.time,
        isEnabled: true,
        repeatDays: Array(state.repeatDays)
      )
      state = reduce(state, .alarmAdded(alarm))
    }
  }

  func reduce(_ state: State, _ action: Action) -> State {
    var newState = state
    switch action {
    case .updateTime(let time):
      newState.time = time
    case .updateTitle(let title):
      newState.title = title
    case .updateRepeatDays(let days):
      newState.repeatDays = days
    case .updateSound(let sound):
      newState.soundTitle = sound
    case .alarmAdded(let alarm):
      newState.alarms.append(alarm)
    }
    return newState
  }
}
