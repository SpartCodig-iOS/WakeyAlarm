//
//  AlarmSoundPicker.swift
//  Alarm
//
//  Created by 김민희 on 11/5/25.
//


import SwiftUI
import DesignSystem

struct AlarmSoundPicker: View {
  @Binding var selectedSound: String

  let sounds = ["Radar", "MorningPulse", "EnergeticRise"]

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("알람 소리")
        .font(.pretendardFont(family: .medium, size: 14))
        .foregroundStyle(.dimGray)

      Menu {
        ForEach(sounds, id: \.self) { sound in
          Button {
            selectedSound = sound
          } label: {
            HStack {
              Text(sound)
              if selectedSound == sound {
                Image(systemName: "checkmark")
              }
            }
          }
        }
      } label: {
        HStack {
          Text(selectedSound.isEmpty ? "Select sound" : selectedSound)
            .font(.pretendardFont(family: .regular, size: 18))
            .foregroundColor(selectedSound.isEmpty ? .lightGray : .materialDark)
            .padding(.trailing, 8)

          Spacer()

          Image(systemName: "chevron.down")
            .foregroundColor(.dimGray)
        }
        .padding(10)
        .background(
          Color.whiteSmoke
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        )
      }
    }
  }
}

#Preview {
  PreviewWrapper()
}

private struct PreviewWrapper: View {
  @State private var sound = "Radar"
  var body: some View {
    AlarmSoundPicker(selectedSound: $sound)
      .padding()
  }
}
