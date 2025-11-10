//
//  AlarmEntity.swift
//  Data
//
//  Created by 김민희 on 11/6/25.
//


import CoreData
import Domain

extension AlarmEntity {
  func toDomain() -> Alarm {
    Alarm(
      id: self.id ?? UUID(),
      title: self.title ?? "",
      time: self.time ?? Date(),
      isEnabled: self.isEnabled,
      repeatDays: self.repeatDaysRaw?
        .split(separator: ",")
        .compactMap { Weekday(rawValue: String($0)) } ?? [],
      soundTitle: self.soundTitle
    )
  }
}

extension Alarm {
  func toEntity(context: NSManagedObjectContext) -> AlarmEntity {
    let entity = AlarmEntity(context: context)
    entity.id = id
    entity.title = title
    entity.time = time
    entity.isEnabled = isEnabled
    entity.repeatDaysRaw = repeatDays.map(\.rawValue).joined(separator: ",")
    entity.soundTitle = soundTitle
    return entity
  }
}
