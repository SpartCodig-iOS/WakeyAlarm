//
//  TimerContainer.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import Foundation
import Combine
import UserNotifications
import AVFoundation

// MARK: - Timer Container (ViewModel)
public final class TimerContainer: ObservableObject {
    // MARK: - Published State
    @Published public private(set) var state: TimerState

    // MARK: - Private Properties
    private let model: TimerModelProtocol
    private let notificationService: TimerNotificationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    private var audioPlayer: AVAudioPlayer?

    // MARK: - Published Alert State
    @Published public var showCompletionAlert: Bool = false

    // MARK: - Initialization
    public init(
        model: TimerModelProtocol = TimerModel(),
        notificationService: TimerNotificationServiceProtocol = TimerNotificationService(),
        initialState: TimerState = TimerState()
    ) {
        self.model = model
        self.notificationService = notificationService
        self.state = initialState

        // 알림 권한 요청
        Task {
            await notificationService.requestAuthorization()
        }
    }

    // MARK: - Intent Processing
    public func send(_ intent: TimerIntent) {
        let (newState, sideEffect) = model.reduce(state: state, intent: intent)
        state = newState

        if let sideEffect = sideEffect {
            handleSideEffect(sideEffect)
        }
    }

    // MARK: - Side Effect Handling
    private func handleSideEffect(_ sideEffect: TimerSideEffect) {
        switch sideEffect {
        case .startTimerTicking:
            startTimer()
            scheduleNotification()

        case .stopTimerTicking:
            stopTimer()
            cancelNotification()

        case .playAlarm:
            playAlarm()
            cancelNotification()

        case .showCompletionAlert:
            displayCompletionAlert()
        }
    }

    // MARK: - Timer Management
    private func startTimer() {
        stopTimer() // 기존 타이머 정리

        // 애니메이션과 동기화를 위해 0.3초 지연
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3초

            self.timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }

                    if self.state.remainingTime > 0 {
                        self.send(.timerTick)
                    } else {
                        self.stopTimer()
                        self.send(.timerCompleted)
                    }
                }
        }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    // MARK: - Alarm & Notifications
    private func playAlarm() {
        // 시스템 사운드 재생 (진동 포함)
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        AudioServicesPlaySystemSound(1005) // 알림 사운드

        print("🔔 타이머 완료! 알람 울림")

        // 완료 알림도 함께 표시
        displayCompletionAlert()
    }

    private func displayCompletionAlert() {
        Task { @MainActor in
            self.showCompletionAlert = true
        }
        print("✅ 타이머 완료 알림")
    }

    // MARK: - Notification Management
    private func scheduleNotification() {
        guard let endDate = state.endDate else { return }
        notificationService.scheduleNotification(endDate: endDate, totalTime: state.totalTime)
    }

    private func cancelNotification() {
        notificationService.cancelNotification()
    }

    // MARK: - Cleanup
    deinit {
        stopTimer()
        cancelNotification()
    }
}
