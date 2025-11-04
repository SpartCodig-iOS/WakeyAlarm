import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project(
  name: "WakeyAlarmWidget",
  settings: .widgetExtensionSetting,
  targets: [
    .target(
      name: "WakeyAlarmWidget",
      destinations: .iOS,
      product: .appExtension,
      bundleId: .appBundleID(name: ".Widget"),
      deploymentTargets: .iOS("16.6"),
      infoPlist: .widgetExtensionInfoPlist,
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .Shared(implements: .Shared),
        .Core(implements: .Core),
        .Presentation(implements: .StopWatch)
        // WidgetKit과 SwiftUI는 시스템 프레임워크로 자동 링크됨
      ]
    )
  ]
)
