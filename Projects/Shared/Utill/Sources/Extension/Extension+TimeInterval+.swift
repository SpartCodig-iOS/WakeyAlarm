//
//  Extension+TimeInterval+.swift
//  Utill
//
//  Created by Wonji Suh  on 11/4/25.
//

import Foundation

public extension TimeInterval {
  var formattedMinutesSecondsCentiseconds: String {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60
    let centiseconds = Int((self - floor(self)) * 100)
    return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
  }
  /// ("MM:SS", ".ff")로 분리된 포맷 (UI에서 메인/소수부 따로 스타일링할 때 유용)
  var minutesSecondsCentisecondsParts: (main: String, decimal: String) {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60
    let centiseconds = Int((self - floor(self)) * 100)
    return (
      String(format: "%02d:%02d", minutes, seconds),
      String(format: ".%02d", centiseconds)
    )
  }
}
