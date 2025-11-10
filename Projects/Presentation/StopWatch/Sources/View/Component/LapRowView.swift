//
//  LapRowView.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/4/25.
//


import SwiftUI
import DesignSystem

public struct LapRowView: View {
  private let indexFromBottom: Int
  private let main: String
  private let decimal: String
  private let diffMain: String
  private let diffDecimal: String
  private let isLast: Bool

  public init(
    indexFromBottom: Int,
    main: String,
    decimal: String,
    diffMain: String,
    diffDecimal: String,
    isLast: Bool
  ) {
    self.indexFromBottom = indexFromBottom
    self.main = main
    self.decimal = decimal
    self.diffMain = diffMain
    self.diffDecimal = diffDecimal
    self.isLast = isLast
  }

  public  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("Lap \(indexFromBottom)")
          .font(.pretendardFont(family: .regular, size: 14))
          .foregroundStyle(.dimGray)

        Spacer()

        HStack(spacing: 24) {
          HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(diffMain)
              .font(.pretendardFont(family: .regular, size: 14))
              .foregroundStyle(.dimGray)

            Text(diffDecimal)
              .font(.pretendardFont(family: .regular, size: 14))
              .foregroundStyle(.dimGray)
              .foregroundStyle(.lightGray)
          }

          HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(main)
              .font(.pretendardFont(family: .regular, size: 16))
              .foregroundStyle(.materialDark)
            Text(decimal)
              .font(.system(size: 16))
              .foregroundStyle(.dimGray)
          }
        }
      }
      .padding(.vertical, 12)

      if !isLast {
        Divider()
          .background(Color.gray.opacity(0.1))
      }
    }
    .textCase(nil)
    .monospacedDigit()
  }
}
