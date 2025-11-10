//
//  RepeatDaySelector.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI
import Shared
import DesignSystem

public struct RepeatDaySelector: View {
  @Binding var selectedDays: Set<Weekday>

  private let weekdays: [Weekday] = [
    .sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday
  ]

  public init(selectedDays: Binding<Set<Weekday>>) {
    self._selectedDays = selectedDays
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("반복")
        .font(.pretendardFont(family: .medium, size: 14))
        .foregroundStyle(.dimGray)

      HStack(spacing: 10) {
        ForEach(weekdays, id: \.id) { day in
          Button {
            toggle(day)
          } label: {
            Text(day.rawValue)
              .font(.pretendardFont(family: .regular, size: 16))
              .frame(width: 35, height: 35)
              .foregroundColor(selectedDays.contains(day) ? .white : .dimGray)
              .background(selectedDays.contains(day) ? .violetPurple : .whiteSmoke)
              .clipShape(Circle())
          }
        }
      }
    }
  }

  private func toggle(_ day: Weekday) {
    if selectedDays.contains(day) {
      selectedDays.remove(day)
    } else {
      selectedDays.insert(day)
    }
  }
}

#Preview {
  RepeatDaySelector(selectedDays: .constant([.wednesday, .thursday, .friday]))
}
