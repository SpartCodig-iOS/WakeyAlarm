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

  public init() {}

    public var body: some View {
        VStack {
          Spacer()
            .frame(height: 20)

          timeTextView()

          stopwatchControls()

          Spacer()
        }
        .padding(24)
    }
}


extension StopWatchView {

  @ViewBuilder
  private func timeTextView() -> some View {
    let progress = store.circleProgress
    let isRunning = store.state.isRunning
    let minHead: CGFloat = 0.02
    let displayTrim = isRunning ? progress : max(progress, minHead)

    ZStack {
      Circle().stroke(.brightGray, lineWidth: 3)

      Circle()
        .trim(from: 0, to: displayTrim)
        .stroke(
          AngularGradient(
            gradient: Gradient(colors: isRunning ? [.violetPurple] : [.brightGray]),
            center: .center
          ),
          style: StrokeStyle(lineWidth: 3, lineCap: .round)
        )
        .rotationEffect(.degrees(-90))
        .animation(.linear(duration: 0.01), value: progress)
        .animation(.easeInOut(duration: 0.2), value: isRunning)

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
        .frame(height: UIScreen.main.bounds.height * 0.08)

      HStack(alignment: .center) {
        CircleButton(
          title: store.state.isRunning ? "Lap": "Reset",
          circleBackground: .white,
          fontColor: store.state.isRunning ? .materialDark : .lightGray,
          useShadow: true,
          tapAction: {
            if store.state.isRunning {
              store.intent(.lapTapped)
            } else {
              store.intent(.resetTapped)
            }
          }
        )

        Spacer()
          .frame(width: 50)

        CircleButton(
          title: store.state.isRunning ? "Stop": "Start",
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


