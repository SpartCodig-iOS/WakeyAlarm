//
//  AddAlarmIntent.swift
//  Alarm
//
//  Created by 김민희 on 11/6/25.
//


import Foundation
import Shared
import Utill

final public class AddAlarmIntent: ObservableObject, BaseIntent {
  public typealias State = AddAlarmState
  public typealias Intent = AddAlarmUserIntent
  public typealias Action = AddAlarmAction

  @Published public private(set) var state = State()

  private let addAlarmUseCase: AddAlarmUseCaseProtocol

  public init(addAlarmUseCase: AddAlarmUseCaseProtocol) {
    self.addAlarmUseCase = addAlarmUseCase
  }

  public func intent(_ userIntent: Intent) {
    switch userIntent {
    case .setTime(let time):
      Task { @MainActor in
        state = reduce(state, .updateTime(time))
      }
    case .setTitle(let title):
      Task { @MainActor in
        state = reduce(state, .updateTitle(title))
      }
    case .setRepeatDays(let days):
      Task { @MainActor in
        state = reduce(state, .updateRepeatDays(days))
      }
    case .setSound(let sound):
      Task { @MainActor in
        state = reduce(state, .updateSound(sound))
      }
    case .addAlarm:
      let alarm = Alarm(
        id: UUID(),
        title: state.title.isEmpty ? "알람" : state.title,
        time: state.time,
        isEnabled: true,
        repeatDays: Array(state.repeatDays),
        soundTitle: state.soundTitle
      )
      Task {
        do {
          try addAlarmUseCase.execute(alarm)
          await MainActor.run {
            state = reduce(state, .alarmAdded(alarm))
          }
        } catch {
          print("Add alarm failed: \(error)")
        }
      }
    case .reset:
      state = AddAlarmState()
    }
  }

  public func reduce(_ state: State, _ action: Action) -> State {
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
