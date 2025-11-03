import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Core",
  bundleId: .appBundleID(name: ".Core"),
  product: .framework,
  settings:  .settings(),
  dependencies: [
    .Data(implements: .Data),
    .Domain(implements: .Domain)
  ],
  sources: ["Sources/**"]
)
