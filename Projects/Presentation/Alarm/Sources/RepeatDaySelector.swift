//
//  RepeatDaySelector.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI
import Domain

public struct RepeatDaySelector: View {
  @Binding var selectedDays: Set<Weekday>

  private let weekdays: [Weekday] = [
    .sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday
  ]

  public init(selectedDays: Binding<Set<Weekday>>) {
    self._selectedDays = selectedDays
  }

  public var body: some View {
    HStack(spacing: 10) {
      ForEach(weekdays, id: \.id) { day in
        Button {
          toggle(day)
        } label: {
          Text(day.rawValue)
            .font(.system(size: 16, weight: .regular))
            .frame(width: 35, height: 35)
            .foregroundColor(selectedDays.contains(day) ? .white : .gray)
            .background(selectedDays.contains(day) ? .blue : .gray.opacity(0.2))
            .clipShape(Circle())
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
    .padding()
    .background(Color.white)
}
