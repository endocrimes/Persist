//
//  NSManagedObject+Helpers.swift
//  Persist
//
//  Created by Daniel Tomlinson on 13/09/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

import Foundation
import CoreData

/**
ManagedObjectType is a protocol that exposes convenience methods for NSManagedObjects.
Default implementations are provided, but they can be overriden by individual classes as needeed.

To opt into these methods, add the ManagedObjectType protocol to your NSManagedObject subclass.
*/
public protocol ManagedObjectType : class {
    typealias T = Self
    
    /**
    The name of the class in the managed object model.
    */
    static func entityName() -> String
    
    /**
    Create a new instance of the model object in the given context.
    
    - parameter context: The NSManagedObjectContext in which to create the object.
    
    - returns: A new instance of the model.
    */
    static func create(inContext context: NSManagedObjectContext) -> T
    
    /**
    Create a new fetch request for the entity.
    */
    static func fetchRequest() -> NSFetchRequest
    
    /**
    Create and execute a fetch request with the given predicate to return all
    matching records of the entity.
    */
    static func findAllMatchingPredicate(predicate: NSPredicate, inContext: NSManagedObjectContext) throws -> [T]
}

extension ManagedObjectType where Self: NSManagedObject {
    public static func entityName() -> String {
        return NSStringFromClass(self)
    }
    
    public static func create(inContext context: NSManagedObjectContext) -> Self {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(entityName(), inManagedObjectContext: context) as? Self else {
            preconditionFailure("Could not find entity named \(entityName()) in context \(context)")
        }

        return object
    }
    
    public static func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: entityName())
    }
    
    public static func findAllMatchingPredicate(predicate: NSPredicate, inContext context: NSManagedObjectContext) throws -> [Self] {
        let fetchRequest = self.fetchRequest()
        fetchRequest.predicate = predicate
        
        let result = try context.executeFetchRequest(fetchRequest)
        return result as? [Self] ?? []
    }
}
