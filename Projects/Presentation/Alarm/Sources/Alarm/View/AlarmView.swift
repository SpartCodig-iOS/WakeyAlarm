//
//  AlarmView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import SwiftUI
import DesignSystem
import Domain

public struct AlarmView: View {
  @StateObject private var alarmIntent: AlarmIntent
  @StateObject private var addAlarmIntent: AddAlarmIntent
  @State private var isShowingAddModal = false

  public init(
    alarmIntent: AlarmIntent,
    addAlarmIntent: AddAlarmIntent
  ) {
    _alarmIntent = StateObject(wrappedValue: alarmIntent)
    _addAlarmIntent = StateObject(wrappedValue: addAlarmIntent)
  }

  public var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 0) {
        Text("알람")
          .font(.pretendardFont(family: .medium, size: 24))
          .foregroundStyle(.materialDark)
          .padding(16)

        Divider()

        HStack {
          Spacer()
          Button {
            withAnimation(.spring()) {
              addAlarmIntent.intent(.reset)
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

        if alarmIntent.state.alarms.isEmpty {
          VStack {
            Spacer()
            HStack {
              Spacer()
              Text("등록된 알람이 없습니다.")
                .foregroundColor(.dimGray)
                .font(.pretendardFont(family: .medium, size: 16))
              Spacer()
            }
            Spacer()
          }
        } else {
          ScrollView {
            VStack(spacing: 12) {
              ForEach(alarmIntent.state.alarms, id: \.id) { alarm in
                AlarmCellView(
                  alarm: alarm,
                  onToggle: { alarmIntent.intent(.toggleAlarm(alarm.id)) },
                  onDelete: { alarmIntent.intent(.deleteAlarm(alarm)) }
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
            withAnimation(.spring()) { isShowingAddModal = false }
          }

        AddAlarmView(
          alarmIntent: alarmIntent,
          addIntent: addAlarmIntent,
          isPresented: $isShowingAddModal
        )
        .padding(.horizontal, 16)
        .transition(.scale.combined(with: .opacity))
        .zIndex(1)
      }
    }
    .onAppear {
      alarmIntent.intent(.loadAlarms)
    }
    .animation(.spring(), value: isShowingAddModal)
  }
}
