//
//  AddAlarmView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import SwiftUI
import DesignSystem

struct AddAlarmView: View {
  @ObservedObject var alarmIntent: AlarmIntent
  @StateObject private var addIntent: AddAlarmIntent
  @Binding var isPresented: Bool

  init(
    alarmIntent: AlarmIntent,
    addIntent: AddAlarmIntent,
    isPresented: Binding<Bool>
  ) {
    self._alarmIntent = ObservedObject(wrappedValue: alarmIntent)
    self._addIntent = StateObject(wrappedValue: addIntent)
    self._isPresented = isPresented
  }

  private var isAddButtonDisabled: Bool {
    addIntent.state.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
    addIntent.state.repeatDays.isEmpty ||
    addIntent.state.soundTitle.isEmpty
  }

  var body: some View {
    VStack(spacing: 16) {
      HStack {
        Spacer()
        Text("알람 추가")
          .font(.pretendardFont(family: .semiBold, size: 18))
        Spacer()
        Button { isPresented = false } label: {
          Image(systemName: "xmark")
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundStyle(.materialDark)
        }
      }

      VStack(alignment: .leading, spacing: 24) {
        TimePickerField(selectedTime: Binding(
          get: { addIntent.state.time },
          set: { addIntent.intent(.setTime($0)) }
        ))

        AlarmTitle(title: Binding(
          get: { addIntent.state.title },
          set: { addIntent.intent(.setTitle($0)) }
        ))

        RepeatDaySelector(selectedDays: Binding(
          get: { addIntent.state.repeatDays },
          set: { addIntent.intent(.setRepeatDays($0)) }
        ))

        AlarmSoundPicker(selectedSound: Binding(
          get: { addIntent.state.soundTitle },
          set: { addIntent.intent(.setSound($0)) }
        ))

        Button {
          addIntent.intent(.addAlarm)
          alarmIntent.intent(.loadAlarms)
          isPresented = false
        } label: {
          Text("추가하기")
            .font(.pretendardFont(family: .medium, size: 14))
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
              (isAddButtonDisabled ? Color.lightGray : Color.violetPurple)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            )
        }
        .disabled(isAddButtonDisabled)
      }
    }
    .padding(25)
    .background(
      Color.white
        .clipShape(RoundedRectangle(cornerRadius: 24))
    )
  }
}
