//
//  Person+CoreDataProperties.swift
//  Persist
//
//  Created by Daniel Tomlinson on 13/09/2015.
//  Copyright © 2015 Daniel Tomlinson. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {
    @NSManaged var name: String?
    @NSManaged var birthday: NSDate?
    @NSManaged var friends: Set<Person>?
}
