//
//  AlarmCellView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI
import Domain

struct AlarmCellView: View {
  @State var alarm: Alarm

  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 8) {
        HStack(alignment: .bottom, spacing: 8) {
          Text(alarm.formattedTime.0)
            .font(.system(size: 36, weight: .regular))
            .foregroundColor(.black)
            .alignmentGuide(.bottom) { dimension in dimension[.lastTextBaseline] }

          Text(alarm.formattedTime.1)
            .font(.system(size: 20, weight: .regular))
            .foregroundColor(.black)
            .alignmentGuide(.bottom) { dimension in dimension[.lastTextBaseline] }
        }

        Text(alarm.title)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.black)

        Text(alarm.repeatDays.map(\.rawValue).joined(separator: ", "))
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.gray)
      }

      Spacer()

      Image(systemName: "trash")
        .resizable()
        .frame(width: 20, height: 20)
        .foregroundStyle(.gray)
        .padding(.trailing, 16)

      Toggle("", isOn: $alarm.isEnabled)
        .fixedSize()
    }
    .padding(20)
    .background(
      Color.white
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    )
    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)

  }
}

#Preview {
  let alarm = Alarm(
    id: UUID(),
    title: "Alarm",
    time: Date(),
    isEnabled: true,
    repeatDays: [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
  )
  AlarmCellView(alarm: alarm)
}
