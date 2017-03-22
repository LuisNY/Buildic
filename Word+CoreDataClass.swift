//
//  Word+CoreDataClass.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/16/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import Foundation
import CoreData


class Word: NSManagedObject {

    
    
    @NSManaged public var kind: String?
    @NSManaged public var language: String?
    @NSManaged public var word: String?
    @NSManaged public var notes: String?
    @NSManaged public var toDictionary: Dictionary?
    @NSManaged public var toOtherWord: NSSet?
    @NSManaged public var fromOtherWord: NSSet?
    
    class func createInManagedObjectContext(_ moc: NSManagedObjectContext, word: String, language: String, kind: String, dictionary: Dictionary) -> Word {

        let newWord = NSEntityDescription.insertNewObject(forEntityName: "Word", into: moc) as! Word

        newWord.word = word
        newWord.kind = kind
        newWord.language = language
        newWord.notes = ""
        dictionary.addWord(newWord)
        newWord.toDictionary = dictionary

        return newWord
    }
    
    func addNotes(_ notes: String) {
        self.notes = notes
    }


    func addConnectionTo(_ newWord: Word) {
        self.mutableSetValue(forKey: "toOtherWord").add(newWord)
    }
    
    func addConnectionFrom(_ newWord: Word) {
        self.mutableSetValue(forKey: "fromOtherWord").add(newWord)
    }
    
    
    
    
    
}
