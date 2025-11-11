import SwiftUI
import Alarm
import StopWatch
import Timer
import Domain

public struct ContentView: View {
  init() {
      @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
      _ = DIContainer.shared
    }

    public var body: some View {
      let container = DIContainer.shared.container

      let fetchUseCase = container.resolve(FetchAlarmsUseCaseProtocol.self)!
      let toggleUseCase = container.resolve(ToggleAlarmUseCaseProtocol.self)!
      let deleteUseCase = container.resolve(DeleteAlarmUseCaseProtocol.self)!
      let addUseCase = container.resolve(AddAlarmUseCaseProtocol.self)!

      let alarmIntent = AlarmIntent(
        fetchAlarmsUseCase: fetchUseCase,
        toggleAlarmUseCase: toggleUseCase,
        deleteAlarmUseCase: deleteUseCase
      )

      let addAlarmIntent = AddAlarmIntent(
        addAlarmUseCase: addUseCase
      )
        TabView {
          AlarmView(alarmIntent: alarmIntent, addAlarmIntent: addAlarmIntent)
                .tabItem {
                    Label("알람", systemImage: "alarm.fill")
                }
            
            StopWatchView(widgetActivityDelegateProvider: {
                return WidgetActivityManager.shared
            })
            .tabItem {
                Label("스톱워치", systemImage: "stopwatch.fill")
            }
            
            TimerView()
                .tabItem {
                    Label("타이머", systemImage: "timer")
                }
        }
    }
}

#Preview {
    ContentView()
}
