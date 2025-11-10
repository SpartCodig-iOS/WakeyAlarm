//
//  TimePickerField.swift
//  Alarm
//
//  Created by 김민희 on 11/5/25.
//

import Foundation
import SwiftUI
import DesignSystem

struct TimePickerField: View {
  @Binding var selectedTime: Date
  @State private var isPickerPresented = false

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("알람 시간을 입력하세요.")
        .font(.pretendardFont(family: .medium, size: 14))
        .foregroundStyle(.dimGray)
      
      Button {
        isPickerPresented.toggle()
      } label: {
        HStack {
          Text(selectedTime, style: .time)
            .font(.pretendardFont(family: .regular, size: 18))
            .foregroundColor(.materialDark)
            .padding(.trailing, 8)

          Image(systemName: "clock")
            .foregroundColor(.dimGray)

          Spacer()
        }
        .padding(10)
        .background(
          Color.whiteSmoke
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        )
      }

      if isPickerPresented {
        DatePicker(
          "",
          selection: $selectedTime,
          displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .frame(maxWidth: .infinity)
        .transition(
          .move(edge: .bottom)
          .combined(with: .opacity)
        )
      }
    }
    .animation(.easeInOut(duration: 0.25), value: isPickerPresented)
  }
}

#Preview {
  PreviewWrapper()
}

private struct PreviewWrapper: View {
  @State private var time = Date()

  var body: some View {
    TimePickerField(selectedTime: $time)
  }
}
