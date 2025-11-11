//
//  StopWatchActivityAttributes.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/5/25.
//

import Foundation

#if canImport(ActivityKit)
@preconcurrency import ActivityKit
#endif

// MARK: - Activity Attributes
/// Live Activity를 위한 데이터 모델
/// 스톱워치의 상태 정보를 Widget과 App 간에 공유하기 위한 구조체

#if canImport(ActivityKit)
@available(iOS 16.1, *)
public struct StopWatchActivityAttributes: ActivityAttributes {

  // MARK: - Content State

  /// Live Activity의 동적 콘텐츠 상태
  public struct ContentState: Codable, Hashable {
    public var elapsedTime: TimeInterval
    public var isRunning: Bool
    public var lapCount: Int
    public var currentLapTime: TimeInterval?
    public var startTime: Date?

    public init(
      elapsedTime: TimeInterval,
      isRunning: Bool,
      lapCount: Int,
      currentLapTime: TimeInterval?,
      startTime: Date?
    ) {
      self.elapsedTime = elapsedTime
      self.isRunning = isRunning
      self.lapCount = lapCount
      self.currentLapTime = currentLapTime
      self.startTime = startTime
    }

    // MARK: - Formatted Display Properties

    /// 경과 시간을 포맷된 문자열로 반환 (MM:SS.HH)
    public var formattedElapsedTime: String {
      let total = isRunning && startTime != nil ? Date().timeIntervalSince(startTime!) + elapsedTime : elapsedTime
      let minutes = Int(total) / 60
      let seconds = Int(total) % 60
      let hundredths = Int((total.truncatingRemainder(dividingBy: 1)) * 100)
      return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }

    /// 현재 랩 시간을 포맷된 문자열로 반환 (MM:SS.HH)
    public var formattedCurrentLapTime: String {
      guard let currentLapTime else { return "00:00.00" }
      let minutes = Int(currentLapTime) / 60
      let seconds = Int(currentLapTime) % 60
      let hundredths = Int((currentLapTime.truncatingRemainder(dividingBy: 1)) * 100)
      return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
  }

  // MARK: - Static Attributes

  /// Activity의 정적 속성 (이름)
  public var name: String

  public init(name: String) {
    self.name = name
  }
}
#endif