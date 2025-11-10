//
//  TimePickerView.swift
//  Timer
//
//  Created by 홍석현 on 2025-11-10
//  Copyright © 2025 DDD , Ltd., All rights reserved.
//

import SwiftUI

// MARK: - 시간 선택 피커 컴포넌트
struct TimePickerView: View {
    @Binding var selectedHours: Int
    @Binding var selectedMinutes: Int
    @Binding var selectedSeconds: Int

    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)

    var body: some View {
        HStack(spacing: -10) {
            // 시간
            HStack(spacing: 2) {
                Picker("시간", selection: $selectedHours) {
                    ForEach(hours, id: \.self) { hour in
                        Text("\(hour)")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.black)
                            .tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60, height: 120)
                .compositingGroup()
                .clipped()

                Text("시간")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.trailing, 8)
            }

            // 분
            HStack(spacing: 2) {
                Picker("분", selection: $selectedMinutes) {
                    ForEach(minutes, id: \.self) { minute in
                        Text("\(minute)")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.black)
                            .tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60, height: 120)
                .compositingGroup()
                .clipped()

                Text("분")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.trailing, 8)
            }

            // 초
            HStack(spacing: 2) {
                Picker("초", selection: $selectedSeconds) {
                    ForEach(seconds, id: \.self) { second in
                        Text("\(second)")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(.black)
                            .tag(second)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 60, height: 120)
                .compositingGroup()
                .clipped()

                Text("초")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
            }
        }
        .frame(width: 260, height: 120)
    }
}
