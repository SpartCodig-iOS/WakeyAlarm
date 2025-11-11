import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Domain",
  bundleId: .appBundleID(name: ".Domain"),
  product: .framework,
  settings:  .settings(),
  dependencies: [

  ],
  sources: ["Sources/**"]
)
