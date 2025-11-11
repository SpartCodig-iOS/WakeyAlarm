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

  public var calendarValue: Int {
    switch self {
    case .sunday: return 1
    case .monday: return 2
    case .tuesday: return 3
    case .wednesday: return 4
    case .thursday: return 5
    case .friday: return 6
    case .saturday: return 7
    }
  }
}
