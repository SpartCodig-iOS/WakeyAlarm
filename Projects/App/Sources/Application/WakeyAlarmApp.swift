import SwiftUI
import Alarm
import Shared

@main
struct WakeyAlarmApp: App {
  init() {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    _ = DIContainer.shared
  }
  var body: some Scene {
    WindowGroup {
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

      AlarmView(
        alarmIntent: alarmIntent,
        addAlarmIntent: addAlarmIntent
      )
    }
  }
}
