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
    .Domain(implements: .Domain),
    .Data(implements: .Data),
    .Shared(implements: .DesignSystem),
    .Shared(implements: .Utill)
  ],
  sources: ["Sources/**"]
)
