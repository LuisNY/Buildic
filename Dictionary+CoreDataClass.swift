//
//  Dictionary+CoreDataClass.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/16/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import Foundation
import CoreData


class Dictionary: NSManagedObject {

    
    @NSManaged public var name: String?
    @NSManaged public var toWord: NSSet?
    
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, name: String) -> Dictionary {

        let newDictionary = NSEntityDescription.insertNewObject(forEntityName: "Dictionary", into: moc) as! Dictionary

        newDictionary.name = name

        return newDictionary
    }

    func addWord(_ newWord: Word) {

        self.mutableSetValue(forKey: "toWord").add(newWord)
    }

    
}
