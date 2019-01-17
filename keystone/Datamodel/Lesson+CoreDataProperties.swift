//
//  Lesson+CoreDataProperties.swift
//  keystone
//
//  Created by Dhaval s on 17/01/19.
//  Copyright © 2019 Dhaval s. All rights reserved.
//
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")}

    @NSManaged public var type: String?
    @NSManaged public var lessontostudents: NSSet? // relashioship NSset because one lesson can have multiple student (Many to one)
}

// MARK: Generated accessors for lessontostudents
extension Lesson {
    @objc(addLessontostudentsObject:)
    @NSManaged public func addToLessontostudents(_ value: Student)

    @objc(removeLessontostudentsObject:)
    @NSManaged public func removeFromLessontostudents(_ value: Student)

    @objc(addLessontostudents:)
    @NSManaged public func addToLessontostudents(_ values: NSSet)

    @objc(removeLessontostudents:)
    @NSManaged public func removeFromLessontostudents(_ values: NSSet)
}
