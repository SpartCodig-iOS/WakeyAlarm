import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Data",
  bundleId: .appBundleID(name: ".Data"),
  product: .staticFramework,
  settings:  .settings(),
  dependencies: [
 
  ],
  sources: ["Sources/**"]
)
