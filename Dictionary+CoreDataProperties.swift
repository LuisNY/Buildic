//
//  Dictionary+CoreDataProperties.swift
//  Buildic
//
//  Created by Luigi Pepe on 2/16/17.
//  Copyright © 2017 Luigi Pepe. All rights reserved.
//

import Foundation
import CoreData




// MARK: Generated accessors for toWord
extension Dictionary {

    @objc(addToWordObject:)
    @NSManaged public func addToToWord(_ value: Word)

    @objc(removeToWordObject:)
    @NSManaged public func removeFromToWord(_ value: Word)

    @objc(addToWord:)
    @NSManaged public func addToToWord(_ values: NSSet)

    @objc(removeToWord:)
    @NSManaged public func removeFromToWord(_ values: NSSet)

}
