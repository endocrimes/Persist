//
//  Persist.swift
//  Persist
//
//  Created by Daniel Tomlinson on 13/09/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

import Foundation
import CoreData

/// A typealias for the "options" parameter of addPersistentStore(withType:configuration:URL:options:)
public typealias CoreDataOptionsType = [ String : AnyObject ]

/// A typealias for the "configuration" parameter of addPersistentStore(withType:configuration:URL:options:)
public typealias CoreDataConfigurationType = String

/**
StoreType is a simple encapsulation of the state required to setup the store
for a Core Data stack.

- InMemory: The InMemory store type is great for test enironments, or
            for providing simple in-memory caches with great querying.

- SQLite:   The SQLLite store is equivalent to NSSQLiteStoreType.
            This is the reccomended store type to use for most situations.

- Binary:   The Binary store is equivalent to NSBinaryStoreType.

- Custom:   Provide a custom NS*Store type.
*/
public enum StoreType {
    case InMemory
    case SQLite(url: NSURL, configuration: CoreDataConfigurationType?, options: CoreDataOptionsType?)
    case Binary(url: NSURL, configuration: CoreDataConfigurationType?, options: CoreDataOptionsType?)
    case Custom(typeName: String, url: NSURL?, configuration: CoreDataConfigurationType?, options: CoreDataOptionsType?)
}

/**
Persist provides a lightweight abstraction around a Core Data Stack.
*/
public class Persist {
    internal var state = State()
    
    /// An NSManagedObjectContext with a MainQueue concurrency type.
    public var managedObjectContext: NSManagedObjectContext {
        return state.mainThreadManagedObjectContext
    }
    
    /**
    Create a new instance of Persist.
    
    - parameter storeType: Provide a StoreType for use in the NSPersistentStore
    - parameter modelURL:  Provide a URL to the desired NSManagedObjectModel
    
    - throws: Propogates Core Data errors back to the Callee
    */
    public init?(storeType: StoreType, modelURL: NSURL) throws {
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            return nil
        }
        
        state.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        state.persistentStore = try setupCoreDataStore(withStoreType: storeType, persistentStoreCoordinator: state.persistentStoreCoordinator!)
        
        guard state.persistentStore != nil else {
            return nil
        }
    }
}
