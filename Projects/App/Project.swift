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
    .SPM.swinject,
    .Presentation(implements: .Presentation),
    .Shared(implements: .Shared),
    .Presentation(implements: .Alarm),
    .Presentation(implements: .StopWatch),
    .Presentation(implements: .Timer),
    .project(target: "WakeyAlarmWidget", path: "../Presentation/Widget"),
    .Data(implements: .Data),
  ],
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  infoPlist: .appInfoPlist,
  schemes: [
    Scheme.makeTestPlanScheme(target: .dev, name: Project.Environment.appName),


  ]

)
