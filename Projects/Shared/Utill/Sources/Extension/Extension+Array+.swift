//
//  Extension+Array+.swift
//  Utill
//
//  Created by Wonji Suh  on 11/4/25.
//

import Foundation

public extension Array {
  /// 조건을 만족하는 인덱스들의 연속 구간을 [Range<Int>]로 반환
  func contiguousRanges(where predicate: (Element) -> Bool) -> [Range<Int>] {
    var result: [Range<Int>] = []
    var start: Int? = nil
    for i in indices {
      if predicate(self[i]) {
        if start == nil { start = i }
      } else if let s = start {
        result.append(s..<i)
        start = nil
      }
    }
    if let s = start { result.append(s..<count) }
    return result
  }
}
