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
        Text("알람 시간을 입력하세요.")
          .font(.pretendardFont(family: .medium, size: 14))

        DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
          .labelsHidden()
          .datePickerStyle(.wheel)

        Text("알람 제목을 입력하세요.")
          .font(.pretendardFont(family: .medium, size: 14))

        TextField("알람 제목", text: .constant(""))
          .padding(10)
          .background(
            Color.whiteSmoke.opacity(0.1)
              .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
          )

        Text("반복")
          .font(.pretendardFont(family: .medium, size: 14))

        RepeatDaySelector(selectedDays: $repeatDays)

        Text("알람 소리")
          .font(.pretendardFont(family: .medium, size: 14))

        //알람소리

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
