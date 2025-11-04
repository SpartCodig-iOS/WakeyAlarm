//
//  AlarmCellView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI

struct AlarmCellView: View {
  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 8) {
        Text("12:00")
          .font(.system(size: 36, weight: .regular))
          .foregroundColor(.black)

        Text("Wake up")
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.black)

        Text("월 화 수 목 금 토 일")
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.gray)
      }

      Spacer()

      Image(systemName: "trash")
        .resizable()
        .frame(width: 20, height: 20)
        .foregroundStyle(.gray)
        .padding(.trailing, 16)

      Toggle("", isOn: .constant(false))
        .fixedSize()
    }
    .padding(20)
    .background(.gray.opacity(0.05))
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
}

#Preview {
  AlarmCellView()
}
