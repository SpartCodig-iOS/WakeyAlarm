//
//  CircleButton.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/4/25.
//

import SwiftUI
import DesignSystem

public struct CircleButton: View {
 private  var title: String
  private var circleBackground: Color
  private var fontColor: Color
  private var useShadow: Bool
  private var tapAction: () -> Void

  public init(
    title: String,
    circleBackground: Color,
    fontColor: Color,
    useShadow: Bool,
    tapAction: @escaping () -> Void
  ) {
    self.title = title
    self.circleBackground = circleBackground
    self.fontColor = fontColor
    self.useShadow = useShadow
    self.tapAction = tapAction
  }

    public var body: some View {
      Circle()
        .fill(circleBackground)
        .frame(width: 80, height: 80)
        .shadow(
            color: .black.opacity(useShadow ? 0.08 : 0),
            radius: useShadow ? 10 : 0,
            x: 0,
            y: useShadow ? 6 : 0
          )
        .overlay {
          Button {
            tapAction()
          } label: {
            Text(title)
              .font(.pretendardFont(family: .medium, size: 20))
              .foregroundStyle(fontColor)
          }
        }
    }
}

