import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: Project.Environment.appName,
  bundleId: .mainBundleID(),
  product: .app,
  settings: .appMainSetting,
  scripts: [],
  dependencies: [
    .Presentation(implements: .Presentation),
    .Shared(implements: .Shared),
    .Presentation(implements: .StopWatch),
    .project(target: "WakeyAlarmWidget", path: "../Widget")
    // ActivityKit은 시스템 프레임워크로 자동 링크
  ],
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  infoPlist: .appInfoPlist,
  schemes: [
    // 테스트 플랜 스킴: 커스텀 구성명 사용 (.dev / .stage / .prod 중 택1)
    Scheme.makeTestPlanScheme(target: .dev, name: Project.Environment.appName),


  ]

)
