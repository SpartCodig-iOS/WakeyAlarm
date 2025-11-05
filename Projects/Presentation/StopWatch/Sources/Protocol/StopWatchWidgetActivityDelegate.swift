//
//  StopWatchWidgetActivityDelegate.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/5/25.
//

import Foundation

// MARK: - Widget Activity Delegate Protocol
/// Widget 모듈과의 통신을 위한 프로토콜
/// Live Activity 관련 기능을 캡슐화하여 모듈 간 결합도를 낮춤
@MainActor
public protocol StopWatchWidgetActivityDelegate: AnyObject {
  /// Live Activity를 시작합니다
  /// - Parameters:
  ///   - elapsedTime: 현재 경과 시간
  ///   - isRunning: 스톱워치 실행 상태
  ///   - lapCount: 랩 카운트
  ///   - currentLapTime: 현재 랩 시간 (옵셔널)
  ///   - startTime: 시작 시간 (옵셔널)
  func startLiveActivity(
    elapsedTime: TimeInterval,
    isRunning: Bool,
    lapCount: Int,
    currentLapTime: TimeInterval?,
    startTime: Date?
  )

  /// Live Activity를 업데이트합니다
  /// - Parameters:
  ///   - elapsedTime: 현재 경과 시간
  ///   - isRunning: 스톱워치 실행 상태
  ///   - lapCount: 랩 카운트
  ///   - currentLapTime: 현재 랩 시간 (옵셔널)
  ///   - startTime: 시작 시간 (옵셔널)
  func updateLiveActivity(
    elapsedTime: TimeInterval,
    isRunning: Bool,
    lapCount: Int,
    currentLapTime: TimeInterval?,
    startTime: Date?
  )

  /// Live Activity를 종료합니다
  func endLiveActivity()
}