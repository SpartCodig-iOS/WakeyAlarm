import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Alarm",
  bundleId: .appBundleID(name: ".Alarm"),
  product: .framework,
  settings:  .settings(),
  dependencies: [
    .Shared(implements: .DesignSystem),
    .Shared(implements: .Utill),
    .Shared(implements: .Shared)
  ],
  sources: ["Sources/**"]
)
