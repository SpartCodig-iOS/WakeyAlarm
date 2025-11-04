import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "StopWatch",
  bundleId: .appBundleID(name: ".StopWatch"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
    .Core(implements: .Core),
    .Shared(implements: .Shared),
  ],
  sources: ["Sources/**"]
)
