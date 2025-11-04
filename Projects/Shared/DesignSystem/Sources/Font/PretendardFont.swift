//
//  PretendardFont.swift
//  DesignSystem
//
//  Created by Wonji Suh  on 11/4/25.
//

import SwiftUI

public struct PretendardFont: ViewModifier {
  public let family: PretendardFontFamily
  public let size: CGFloat

  public init(
    family: PretendardFontFamily,
    size: CGFloat
  ) {
    self.family = family
    self.size = size
  }

  public func body(content: Content) -> some View {
    return content.font(.custom("PretendardVariable-\(family)", fixedSize: size))
  }
}

 public extension Font {
    static func pretendardFont(family: PretendardFontFamily, size: CGFloat) -> Font{
    let font = Font.custom("PretendardVariable-\(family)", size: size)
    return font
  }
}
