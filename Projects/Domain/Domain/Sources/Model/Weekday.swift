//
//  Weekday.swift
//  Domain
//
//  Created by 김민희 on 11/4/25.
//

import Foundation

public enum Weekday: String {
  case sunday = "일"
  case monday = "월"
  case tuesday = "화"
  case wednesday = "수"
  case thursday = "목"
  case friday = "금"
  case saturday = "토"

  public var id: String { self.rawValue }
}
