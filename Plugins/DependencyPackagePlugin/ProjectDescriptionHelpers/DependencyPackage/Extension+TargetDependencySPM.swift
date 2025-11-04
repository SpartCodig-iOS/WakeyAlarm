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
  static let algorithms = TargetDependency.external(name: "Algorithms", condition: .none)

  // MARK: - Apple Frameworks (시스템 프레임워크는 자동으로 링크됨)
  // WidgetKit, SwiftUI, ActivityKit은 시스템 프레임워크로 별도 의존성 정의 불필요
}
