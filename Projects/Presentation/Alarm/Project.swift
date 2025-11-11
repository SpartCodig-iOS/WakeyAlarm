import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Alarm",
  bundleId: .appBundleID(name: ".Alarm"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Shared(implements: .DesignSystem),
    .Shared(implements: .Utill),
    .Domain(implements: .Domain)
  ],
  sources: ["Sources/**"]
)
