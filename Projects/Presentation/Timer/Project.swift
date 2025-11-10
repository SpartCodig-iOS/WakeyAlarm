import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Timer",
  bundleId: .appBundleID(name: ".Timer"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Core(implements: .Core),
    .Shared(implements: .Shared)
  ],
  sources: ["Sources/**"]
)
