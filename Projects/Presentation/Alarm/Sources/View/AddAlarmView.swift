//
//  AddAlarmView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI
import Domain
import DesignSystem

struct AddAlarmView: View {
  @State private var time = Date()
  @State private var repeatDays: Set<Weekday> = []
  @State private var soundTitle: String = ""

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        EmptyView()
          .frame(width: 16, height: 16)

        Spacer()

        Text("알람 추가")
          .font(.pretendardFont(family: .semiBold, size: 18))

        Spacer()

        Button {
          print("close")
        } label: {
          Image(systemName: "xmark")
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundStyle(.materialDark)
        }
      }

      VStack(alignment: .leading, spacing: 24) {
        TimePickerField(selectedTime: $time)

        AlarmTitle()

        RepeatDaySelector(selectedDays: $repeatDays)

        AlarmSoundPicker(selectedSound: $soundTitle)

        Button {
          print("add alarm")
        } label: {
          Text("추가하기")
            .font(.pretendardFont(family: .medium, size: 14))
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
              Color.violetPurple
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            )
        }

      }
    }
    .padding(.horizontal, 25)
  }
}

#Preview {
  AddAlarmView()
}
