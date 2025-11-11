import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "Utill",
  bundleId: .appBundleID(name: ".Utill"),
  product: .framework,
  settings:  .settings(),
  dependencies: [

  ],
  sources: ["Sources/**"]
)
