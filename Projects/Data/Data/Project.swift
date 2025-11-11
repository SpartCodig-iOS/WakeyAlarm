import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Data",
  bundleId: .appBundleID(name: ".Data"),
  product: .framework,
  settings:  .settings(),
  dependencies: [
    .Domain(implements: .Domain),
  ],
  sources: ["Sources/**"],
  coreDataModels: [
      .coreDataModel("Resources/WakeyAlarm.xcdatamodeld")
  ]

)
