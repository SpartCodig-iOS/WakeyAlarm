//
//  AlarmCellView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import SwiftUI
import Domain
import DesignSystem

struct AlarmCellView: View {
  let alarm: Alarm
  var onToggle: () -> Void
  var onDelete: () -> Void

  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 8) {
        // 시간
        HStack(alignment: .bottom, spacing: 8) {
          Text(alarm.formattedTime.0)
            .font(.pretendardFont(family: .regular, size: 36))
            .foregroundColor(.materialDark)
            .alignmentGuide(.bottom) { dimension in
              dimension[.lastTextBaseline]
            }

          Text(alarm.formattedTime.1)
            .font(.pretendardFont(family: .regular, size: 20))
            .foregroundColor(.materialDark)
            .alignmentGuide(.bottom) { dimension in
              dimension[.lastTextBaseline]
            }
        }

        // 제목
        Text(alarm.title)
          .font(.pretendardFont(family: .regular, size: 14))
          .foregroundColor(.materialDark)

        // 반복 요일
        if !alarm.repeatDays.isEmpty {
          Text(alarm.repeatDays.map(\.rawValue).joined(separator: " "))
            .font(.pretendardFont(family: .regular, size: 14))
            .foregroundColor(.dimGray)
        }
      }

      Spacer(minLength: 12)

      // 삭제 버튼
      Button(action: {
        withAnimation { onDelete() }
      }) {
        Image(systemName: "trash")
          .resizable()
          .frame(width: 20, height: 20)
          .foregroundStyle(.lightGray)
          .padding(.trailing, 16)
      }
      .buttonStyle(.plain)

      // 알람 on/off 토글
      Toggle("", isOn: Binding(
        get: { alarm.isEnabled },
        set: { _ in onToggle() }
      ))
      .labelsHidden()
      .toggleStyle(SwitchToggleStyle(tint: .violetPurple))
    }
    .padding(20)
    .background(Color.whiteSmoke)
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
  }
}

#Preview {
  let alarm = Alarm(
    id: UUID(),
    title: "아침 알람",
    time: Date(),
    isEnabled: true,
    repeatDays: [.monday, .wednesday, .friday]
  )

  AlarmCellView(
    alarm: alarm,
    onToggle: { print("toggle!") },
    onDelete: { print("delete!") }
  )
}
