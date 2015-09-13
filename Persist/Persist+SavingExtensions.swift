//
//  Persist+SavingExtensions.swift
//  Persist
//
//  Created by Daniel Tomlinson on 13/09/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    /**
    Asynchronously save all the changes in the context to it's parent, or if it
    is connected directly to an NSPersistentStoreCoordinator to the persistent
    store.
    
    - parameter completion: A block to be called when the context has been saved.
    */
    public func saveAsync(completion: (error: ErrorType?) -> ()) {
        performBlock {
            do {
                try self.save()
                completion(error: nil)
            }
            catch let error {
                completion(error: error)
            }
        }
    }
}

extension Persist {
    /**
    Asynchronously save all the changes in the stack to the on disk store.
    
    - parameter completion: A block to be called when all the contexts have been saved.
    */
    public func saveToDiskAsync(completion: (error: ErrorType?) -> ()) {
        let mainThreadContext = state.mainThreadManagedObjectContext
        let privateContext = state.privateManagedObjectContext
       
        mainThreadContext.saveAsync { error in
            guard error == nil else {
                completion(error: error)
                return
            }
            
            privateContext.saveAsync(completion)
        }
    }
}