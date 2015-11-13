//
//  Helpers.swift
//  Persist
//
//  Created by Danielle Lancashire on 13/09/2015.
//  Copyright © 2015 Danielle Lancashire. All rights reserved.
//

import Foundation

func pathForTemporaryFile(name: String) -> String {
    let temporaryDirectory = NSTemporaryDirectory() as NSString
    
    return temporaryDirectory.stringByAppendingPathComponent(name)
}

func setupDependenciesOfPath(path: NSString) {
    let dirPath = path.stringByDeletingPathExtension
    let fileManager = NSFileManager.defaultManager()
    _ = try? fileManager.removeItemAtPath(dirPath)
    _ = try? fileManager.createDirectoryAtPath(dirPath, withIntermediateDirectories: true, attributes: nil)
}
