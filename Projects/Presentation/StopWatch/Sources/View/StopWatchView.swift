//
//  StopWatchView.swift
//  StopWatch
//
//  Created by Wonji Suh  on 11/4/25.
//

import SwiftUI
import DesignSystem

public struct StopWatchView: View {

  @StateObject private var store = StopWatchIntent()

  // WidgetActivityDelegate 주입을 위한 클로저 (메모리 효율적)
  private let widgetActivityDelegateProvider: (() -> StopWatchWidgetActivityDelegate?)?

  public init(widgetActivityDelegateProvider: (() -> StopWatchWidgetActivityDelegate?)? = nil) {
    self.widgetActivityDelegateProvider = widgetActivityDelegateProvider
  }

    public var body: some View {
        VStack {
          Spacer()
            .frame(height: 20)

          timeTextView()

          stopwatchControls()

          Spacer()
            .frame(height: 20)

          LapsCardView(
            laps: store.state.laps,
            include: { _ in true }
          )

          Spacer()

        }
        .padding(24)
        .onAppear {
          setupWidgetDelegate()
        }
    }
}


extension StopWatchView {

  // MARK: - Widget Integration

  private func setupWidgetDelegate() {
    // iOS 16.1+에서만 delegate 설정 시도
    if #available(iOS 16.1, *) {
      print("📱 iOS 16.1+ - WidgetActivityDelegate 설정 시도")

      // 델리게이트 프로바이더를 통해 안전하게 주입
      if let delegate = widgetActivityDelegateProvider?() {
        store.setWidgetActivityDelegate(delegate)
        print("✅ WidgetActivityDelegate 주입 성공")
      } else {
        print("⚠️ WidgetActivityDelegate 프로바이더가 없습니다")
      }
    } else {
      print("📱 iOS 16.0 이하 - Live Activity 미지원")
    }
  }

  @ViewBuilder
  private func timeTextView() -> some View {
    // 메모리 효율적인 계산 (필요한 것만 계산)
    let elapsed = store.state.elapsed
    let isRunning = store.state.isRunning
    let isZero = elapsed == 0

    // 진행도 계산 최적화
    let progress = isZero ? 0 : CGFloat(elapsed.truncatingRemainder(dividingBy: 60) / 60.0)
    let strokeColors: [Color] = isZero ? [.brightGray] : [.violetPurple]
    let displayTrim: CGFloat = isZero ? 0 : max(progress, 0.02)

    ZStack {
      Circle().stroke(.brightGray, lineWidth: 3)

      Circle()
        .trim(from: 0, to: displayTrim)
        .stroke(
          AngularGradient(gradient: Gradient(colors: strokeColors), center: .center),
          style: StrokeStyle(lineWidth: 3, lineCap: .round)
        )
        .rotationEffect(.degrees(-90))
        .animation(.linear(duration: 0.1), value: progress)

      if store.state.resetAnimationTrimAmount > 0 {
        Circle()
          .trim(from: 0, to: store.state.resetAnimationTrimAmount)
          .stroke(
            AngularGradient(gradient: Gradient(colors: [.violetPurple]), center: .center),
            style: StrokeStyle(lineWidth: 3, lineCap: .round)
          )
          .rotationEffect(.degrees(-90))
          .animation(.easeIn(duration: 0.18), value: store.state.resetAnimationTrimAmount)
      }

      HStack(alignment: .firstTextBaseline, spacing: 0) {
        Text(store.formattedMain)
          .font(.pretendardFont(family: .regular, size: 48))
          .foregroundStyle(.materialDark)
        Text(store.formattedHundredths)
          .font(.pretendardFont(family: .regular, size: 24))
          .foregroundStyle(.dimGray)
          .padding(.leading, 4)
      }
      .monospacedDigit()
    }
    .frame(width: 280, height: 280)
  }


  @ViewBuilder
  private func stopwatchControls() -> some View {
    VStack {
      Spacer()
        .frame(height: UIScreen.main.bounds.height * 0.05)

      HStack(alignment: .center) {
        CircleButton(
          title: store.state.isRunning ? "Lap" : "Reset",
          circleBackground: .white,
          fontColor: store.state.isRunning ? .materialDark : .lightGray,
          useShadow: true,
          tapAction: {
            if store.state.isRunning {
              withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                store.intent(.lapTapped)
              }
            } else if store.state.elapsed > 0 {
              store.intent(.resetTapped)
            }
          }
        )
        .disabled(!store.state.isRunning && store.state.elapsed == 0)

        Spacer().frame(width: 50)


        CircleButton(
          title: store.state.isRunning ? "Stop" : "Start",
          circleBackground: store.state.isRunning ? .goldenYellow : .mintGreen,
          fontColor: .whiteSmoke,
          useShadow: true,
          tapAction: {
            if store.state.isRunning {
              store.intent(.stopTapped)
            } else {
              store.intent(.startTapped)
            }
          }
        )
      }
    }
  }
}


