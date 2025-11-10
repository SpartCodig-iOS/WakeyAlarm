//
//  LapsCardView.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/4/25.
//


import SwiftUI
import Shared

public struct LapsCardView: View {
  private let laps: [TimeInterval]
  private let include: (TimeInterval) -> Bool

  private let maxListHeight: CGFloat = 192

  @State private var measuredListHeight: CGFloat = 0

  public init(
    laps: [TimeInterval],
    include: @escaping (TimeInterval) -> Bool = { _ in true }
  ) {
    self.laps = laps
    self.include = include
  }

  public var body: some View {
    if laps.isEmpty {
      EmptyView()
    } else {
      content()
    }
  }
}

private extension LapsCardView {
  @ViewBuilder
  func content() -> some View {
    VStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 12) {
        Text("Laps")
          .font(.pretendardFont(family: .regular, size: 14))
          .foregroundStyle(.materialDark)

        ScrollView {
          VStack(spacing: 0) {
            let ranges: [Range<Int>] = laps.contiguousRanges(where: include)
            let indices: [Int] = ranges.flatMap { Array($0) }

            ForEach(indices, id: \.self) { i in
              lapRow(i)
                .transition(
                  .asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .opacity
                  )
                )
            }
          }
          .background(
            GeometryReader { proxy in
              Color.clear.preference(key: HeightPrefKey.self, value: proxy.size.height)
            }
          )
        }
        .scrollIndicators(.hidden)
        .onPreferenceChange(HeightPrefKey.self) { h in
          withAnimation(.easeInOut(duration: 0.2)) {
            measuredListHeight = min(h, maxListHeight)
          }
        }
        .frame(height: measuredListHeight)
      }
      .padding(16)
      .background(
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .fill(.whiteSmoke)
          .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
      )
      .padding(.horizontal, 8)
      .padding(.top, 16)
    }
    .animation(.spring(response: 0.25, dampingFraction: 0.85), value: laps.count)
  }

  @ViewBuilder
  func lapRow(_ i: Int) -> some View {
    let lap: TimeInterval = laps[i]
    let (main, decimal) = lap.minutesSecondsCentisecondsParts

    let baseDiff: TimeInterval = (i == laps.count - 1) ? lap : (lap - laps[i + 1])
    let diff: TimeInterval = max(baseDiff, 0)  
    let (diffMain, diffDecimal) = diff.minutesSecondsCentisecondsParts

    LapRowView(
      indexFromBottom: laps.count - i,
      main: main,
      decimal: decimal,
      diffMain: diffMain,
      diffDecimal: diffDecimal,
      isLast: i == laps.count - 1
    )
  }
}

private struct HeightPrefKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}
