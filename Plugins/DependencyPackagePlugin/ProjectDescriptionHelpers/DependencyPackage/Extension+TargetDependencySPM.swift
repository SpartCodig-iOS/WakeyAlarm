//
//  Extension+TargetDependencySPM.swift
//  DependencyPackagePlugin
//
//  Created by 서원지 on 4/19/24.
//

import ProjectDescription

public extension TargetDependency.SPM {
  static let swinject = TargetDependency.external(name: "Swinject", condition: .none)
  static let weaveDI = TargetDependency.external(name: "WeaveDI", condition: .none)
}
