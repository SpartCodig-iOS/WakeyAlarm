import Foundation
import ProjectDescription
import DependencyPlugin
import ProjectTemplatePlugin
import ProjectTemplatePlugin
import DependencyPackagePlugin

let project = Project.makeAppModule(
  name: "ThirdParty",
  bundleId: .appBundleID(name: ".ThirdParty"),
  product: .framework,
  settings:  .settings(),
  dependencies: [
    .SPM.weaveDI
  ],
  sources: ["Sources/**"]
)
