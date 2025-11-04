//
//  BaseintentProtocol.swift
//  Utill
//
//  Created by Wonji Suh  on 11/4/25.
//

import Foundation

@MainActor
public protocol BaseIntent {
  associatedtype State
  associatedtype Intent
  associatedtype Action

  var state: State { get }  // get만 요구
  func intent(_ userIntent: Intent)
  func reduce(_ state: State, _ action: Action) -> State
}
