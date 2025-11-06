//
//  AlarmView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import Foundation
import SwiftUI
import Domain
import DesignSystem

public struct AlarmView: View {
  @StateObject private var intent = AlarmIntent()
  @State private var isShowingAddModal = false

  public init() {
  }

  public var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 0) {
        Text("알람")
          .font(.pretendardFont(family: .medium, size: 24))
          .foregroundStyle(.materialDark)
          .padding(16)

        Divider()

        HStack(spacing: 0) {
          Spacer()
          Button {
            withAnimation(.spring()) {
              isShowingAddModal = true
            }
          } label: {
            Image(systemName: "plus")
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundStyle(.violetPurple)
          }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)

        if intent.state.alarms.isEmpty {
          VStack(spacing: 0) {
            HStack(spacing: 0) {
              Spacer()
              Text("등록된 알람이 없습니다.")
                .foregroundColor(.dimGray)
                .font(.pretendardFont(family: .medium, size: 16))
                .padding(.top, 100)
              Spacer()
            }
            Spacer()
          }
        } else {
          ScrollView {
            VStack(spacing: 12) {
              ForEach(intent.state.alarms, id: \.id) { alarm in
                AlarmCellView(
                  alarm: alarm,
                  onToggle: { intent.intent(.toggleAlarm(alarm.id)) },
                  onDelete: { intent.intent(.deleteAlarm(alarm.id)) }
                )
              }
            }
            .padding(16)
          }
        }
      }

      if isShowingAddModal {
        Color.black.opacity(0.4)
          .ignoresSafeArea()
          .transition(.opacity)
          .onTapGesture {
            withAnimation(.spring()) {
              isShowingAddModal = false
            }
          }

        AddAlarmView(
          alarmIntent: intent,
          isPresented: $isShowingAddModal
        )
        .padding(.horizontal, 16)
        .transition(.scale.combined(with: .opacity))
        .zIndex(1)
      }
    }
    .animation(.spring(), value: isShowingAddModal)
  }
}

#Preview {
  AlarmView()
}
