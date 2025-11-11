// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
  productTypes: ["Swinject": .framework]
)
#endif

let package = Package(
  name: "AlarmApp",
  dependencies: [
    .package(url: "https://github.com/Roy-wonji/WeaveDI.git", from: "3.3.1"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.10.0"),
  ]
)
