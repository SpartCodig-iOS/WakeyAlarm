//
//  AlarmTitle.swift
//  Alarm
//
//  Created by 김민희 on 11/5/25.
//

import SwiftUI
import DesignSystem

struct AlarmTitle: View {
  @Binding var title: String

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("알람 제목을 입력하세요.")
        .font(.pretendardFont(family: .medium, size: 14))
        .foregroundStyle(.dimGray)

      TextField("알람 제목", text: $title)
        .padding(10)
        .background(
          Color.whiteSmoke
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        )
    }
  }
}

