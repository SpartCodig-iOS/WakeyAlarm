//
//  AlarmRepository.swift
//  Data
//
//  Created by 김민희 on 11/6/25.
//

import Foundation
import CoreData
import Domain

public final class AlarmRepository: AlarmRepositoryProtocol {
  private let context: NSManagedObjectContext

  public init(context: NSManagedObjectContext = PersistenceController.shared.context) {
    self.context = context
  }

  public func fetchAlarms() throws -> [Alarm] {
    let request = NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    let result = try context.fetch(request)
    return result.map { $0.toDomain() }
  }

  public func addAlarm(_ alarm: Alarm) throws {
    _ = alarm.toEntity(context: context)
    try context.save()
  }

  public func toggleAlarm(id: UUID) throws {
    let request = NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    if let entity = try context.fetch(request).first {
      entity.isEnabled.toggle()
      try context.save()
    }
  }

  public func deleteAlarm(id: UUID) throws {
    let request = NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    if let entity = try context.fetch(request).first {
      context.delete(entity)
      try context.save()
    }
  }
}
