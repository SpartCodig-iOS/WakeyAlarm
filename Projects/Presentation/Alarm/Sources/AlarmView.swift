//
//  AlarmView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI
import Domain
import DesignSystem

struct AlarmView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text("알람")
        .font(.pretendardFont(family: .medium, size: 24))
        .foregroundStyle(.materialDark)
        .padding(16)

      Divider()

      HStack(spacing: 0) {
        Spacer()

        Button {
          print("add alarm")
        } label: {
          Image(systemName: "plus")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundStyle(.violetPurple)
        }
      }
      .padding(.horizontal, 16)
      .padding(.top, 8)

      ScrollView {
        AlarmCellView(alarm: Alarm(id: UUID(), title: "알람1", time: Date(), isEnabled: true, repeatDays: [.friday]))
      }
      .padding(16)
    }
  }
}

#Preview {
  AlarmView()
}
