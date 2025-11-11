//
//  TimerActivityAttributes.swift
//  Timer
//
//  Created by 홍석현 on 11/11/25.
//

import Foundation
import ActivityKit

public struct TimerActivityAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        public var totalTime: TimeInterval
        public var remainingTime: TimeInterval
        public var endDate: Date?
        public var isRunning: Bool
        public var isPaused: Bool
        
        public init(
            totalTime: TimeInterval,
            remainingTime: TimeInterval,
            endDate: Date? = nil,
            isRunning: Bool,
            isPaused: Bool
        ) {
            self.totalTime = totalTime
            self.remainingTime = remainingTime
            self.endDate = endDate
            self.isRunning = isRunning
            self.isPaused = isPaused
        }
    }
    
    public init() {

    }

}

// MARK: - Preview Support
extension TimerActivityAttributes {
    public static var preview: TimerActivityAttributes {
        TimerActivityAttributes()
    }
}

extension TimerActivityAttributes.ContentState {
    public static var sample: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(
            totalTime: 300,
            remainingTime: 185,
            endDate: Date().addingTimeInterval(185),
            isRunning: true,
            isPaused: false
        )
    }

    public static var almostDone: TimerActivityAttributes.ContentState {
        TimerActivityAttributes.ContentState(
            totalTime: 300,
            remainingTime: 60,
            endDate: Date().addingTimeInterval(60),
            isRunning: true,
            isPaused: false
        )
    }
}
