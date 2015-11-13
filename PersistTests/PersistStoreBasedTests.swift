//
//  PersistTests.swift
//  PersistTests
//
//  Created by Danielle Lancashire on 13/09/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

import XCTest
import CoreData
@testable import Persist

// MARK - Abstract

class PersistBaseTests: XCTestCase {
    func storeType() -> StoreType {
        return .InMemory
    }
    
    func modelURL() -> NSURL {
        let bundle = NSBundle(forClass: self.dynamicType)
        let modelURL = bundle.URLForResource("SimpleModel", withExtension: "momd")!

        return modelURL
    }
    
    var sut: Persist!
    
    override func setUp() {
        super.setUp()
        
        sut = try! Persist(storeType: storeType(), modelURL: modelURL())
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK - General Tests
    
    func test_subsequent_calls_to_managedObjectContext_yield_the_same_context() {
        let context1 = sut.managedObjectContext
        let context2 = sut.managedObjectContext
        
        XCTAssertEqual(context1, context2)
    }
    
    func test_can_insert_object_into_context() {
        let context = sut.managedObjectContext
        
        let person = Person.create(inContext: context)
        person.name = "Henri"
        person.birthday = NSDate()
        
        do {
            try context.save()
        }
        catch {
            XCTFail("Failed to save context")
        }
    }
}

class PersistPersistentStoreBaseTests: PersistBaseTests {
    override func storeType() -> StoreType {
        let path = pathForTemporaryFile("test.sqlite")
        setupDependenciesOfPath(path)
        let url = NSURL(fileURLWithPath: path)
        let configuration: CoreDataConfigurationType? = nil
        let options: CoreDataOptionsType? = nil
        
        return .SQLite(url: url, configuration: configuration, options: options)
    }
    
    // TODO: Test that we can save to disk, spin up another stack, and retreive the data.
}

// MARK - Concrete

class PersistInMemoryTests: PersistBaseTests {
    override func storeType() -> StoreType {
        return .InMemory
    }
}

class PersistSQLiteTests: PersistPersistentStoreBaseTests {
    override func storeType() -> StoreType {
        let path = pathForTemporaryFile("test.sqlite")
        setupDependenciesOfPath(path)
        let url = NSURL(fileURLWithPath: path)
        let configuration: CoreDataConfigurationType? = nil
        let options: CoreDataOptionsType? = nil
        
        return .SQLite(url: url, configuration: configuration, options: options)
    }
}

class PersistBinaryTests: PersistPersistentStoreBaseTests {
    override func storeType() -> StoreType {
        let path = pathForTemporaryFile("test.binarystore")
        setupDependenciesOfPath(path)
        let url = NSURL(fileURLWithPath: path)
        let configuration: CoreDataConfigurationType? = nil
        let options: CoreDataOptionsType? = nil
        
        return .Binary(url: url, configuration: configuration, options: options)
    }
}
