//
//  Internal.swift
//  Persist
//
//  Created by  Danielle Lancashireon 13/09/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

import Foundation
import CoreData

struct State {
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var persistentStore: NSPersistentStore?
    
    /**
        NOTE: If any of these properties are ever nil, you're having a seriously
        bad day and you probably wanna know about it.
    */
    
    lazy var privateManagedObjectContext: NSManagedObjectContext! = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    lazy var mainThreadManagedObjectContext: NSManagedObjectContext! = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.parentContext = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
}

func setupCoreDataStore(withStoreType storeType: StoreType, persistentStoreCoordinator: NSPersistentStoreCoordinator) throws -> NSPersistentStore? {
    switch storeType {
    case .InMemory:
        return try setupPersistentStore(NSInMemoryStoreType, coordinator: persistentStoreCoordinator)
    case .SQLite(let URL, let configuration, let options):
        return try setupPersistentStore(NSSQLiteStoreType, coordinator: persistentStoreCoordinator, URL: URL, configuration: configuration, options: options)
    case .Binary(let URL, let configuration, let options):
        return try setupPersistentStore(NSBinaryStoreType, coordinator: persistentStoreCoordinator, URL: URL, configuration: configuration, options: options)
    case .Custom(let type, let URL, let configuration, let options):
        return try setupPersistentStore(type, coordinator: persistentStoreCoordinator, URL: URL, configuration: configuration, options: options)

    }
}

private func setupPersistentStore(storeType: String, coordinator: NSPersistentStoreCoordinator, configuration: String? = nil, URL: NSURL? = nil, options: [ String : AnyObject ]? = nil) throws -> NSPersistentStore? {
    let ps = try coordinator.addPersistentStoreWithType(storeType, configuration: configuration, URL: URL, options: options)
    
    return ps
}