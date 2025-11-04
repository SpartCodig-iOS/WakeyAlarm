//
//  AddAlarmView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI
import Domain

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
          .font(.system(size: 18, weight: .semibold))

        Spacer()

        Button {
          print("close")
        } label: {
          Image(systemName: "xmark")
            .resizable()
            .frame(width: 16, height: 16)
            .foregroundStyle(.gray)
        }
      }

      VStack(alignment: .leading, spacing: 24) {
        Text("알람 시간을 입력하세요.")
          .font(.system(size: 14, weight: .medium))

        DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
          .labelsHidden()
          .datePickerStyle(.wheel)

        Text("알람 제목을 입력하세요.")
          .font(Font.system(size: 14, weight: .medium))

        TextField("알람 제목", text: .constant(""))
          .padding(10)
          .background(
            Color.gray.opacity(0.1)
              .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
          )

        Text("반복")
          .font(Font.system(size: 14, weight: .medium))

        RepeatDaySelector(selectedDays: $repeatDays)

        Text("알람 소리")
          .font(Font.system(size: 14, weight: .medium))

        //알람소리

        Button {
          print("add alarm")
        } label: {
          Text("추가하기")
            .font(.system(size: 14, weight: .medium))
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
              Color.blue
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
