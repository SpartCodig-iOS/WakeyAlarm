//
//  AlarmView.swift
//  Alarm
//
//  Created by 김민희 on 11/4/25.
//

import SwiftUI
import Domain
import Data
import DesignSystem

public struct AlarmView: View {
  @StateObject private var alarmIntent: AlarmIntent
  @StateObject private var addAlarmIntent: AddAlarmIntent
  @State private var isShowingAddModal = false

  public init(
     fetchAlarmsUseCase: FetchAlarmsUseCaseProtocol = FetchAlarmsUseCase(repository:
   AlarmRepository()),
     toggleAlarmUseCase: ToggleAlarmUseCaseProtocol = ToggleAlarmUseCase(repository:
   AlarmRepository()),
     deleteAlarmUseCase: DeleteAlarmUseCaseProtocol = DeleteAlarmUseCase(repository:
   AlarmRepository()),
     addAlarmUseCase: AddAlarmUseCaseProtocol = AddAlarmUseCase(repository:
   AlarmRepository())
   ) {
     let alarmIntent = AlarmIntent(
       fetchAlarmsUseCase: fetchAlarmsUseCase,
       toggleAlarmUseCase: toggleAlarmUseCase,
       deleteAlarmUseCase: deleteAlarmUseCase
     )
     let addAlarmIntent = AddAlarmIntent(addAlarmUseCase: addAlarmUseCase)
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
            Text("등록된 알람이 없습니다.")
              .foregroundColor(.dimGray)
              .font(.pretendardFont(family: .medium, size: 16))
            Spacer()
          }
        } else {
          ScrollView {
            VStack(spacing: 12) {
              ForEach(alarmIntent.state.alarms, id: \.id) { alarm in
                AlarmCellView(
                  alarm: alarm,
                  onToggle: { alarmIntent.intent(.toggleAlarm(alarm.id)) },
                  onDelete: { alarmIntent.intent(.deleteAlarm(alarm.id)) }
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
