//
//  PersistenceController.swift
//  Data
//
//  Created by 김민희 on 11/6/25.
//

//import CoreData
//
//public struct PersistenceController {
//  public static let shared = PersistenceController()
//  public let container: NSPersistentContainer
//
//  public init(inMemory: Bool = false) {
//
//    container = NSPersistentContainer(name: "WakeyAlarm")
//    if inMemory {
//      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
//    }
//    container.loadPersistentStores { _, error in
//      if let error = error as NSError? {
//        fatalError("CoreData Load Error: \(error), \(error.userInfo)")
//      }
//    }
//    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//    container.viewContext.automaticallyMergesChangesFromParent = true
//  }
//
//  public var context: NSManagedObjectContext { container.viewContext }
//}

import CoreData

public struct PersistenceController {
    public static let shared = PersistenceController()
    public let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        // ✅ 1. Data 모듈 번들 지정
        let bundle = Bundle(for: PersistenceMarker.self)
        guard let modelURL = bundle.url(forResource: "WakeyAlarm", withExtension: "momd") else {
            fatalError("❌ Could not find WakeyAlarm.momd in bundle: \(bundle.bundleURL)")
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("❌ Failed to load model from: \(modelURL)")
        }

        // ✅ 2. 직접 모델 지정
        container = NSPersistentContainer(name: "WakeyAlarm", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData Load Error: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    public var context: NSManagedObjectContext { container.viewContext }
}

// ✅ 3. 번들 참조용 더미 클래스
final class PersistenceMarker {}
