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
    .project(target: "WakeyAlarmWidget", path: "../Presentation/Widget")
  ],
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  infoPlist: .appInfoPlist,
  schemes: [
    Scheme.makeTestPlanScheme(target: .dev, name: Project.Environment.appName),


  ]

)
