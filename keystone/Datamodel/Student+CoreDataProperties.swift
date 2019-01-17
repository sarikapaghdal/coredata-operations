//
//  Student+CoreDataProperties.swift
//  keystone
//
//  Created by Dhaval s on 17/01/19.
//  Copyright © 2019 Dhaval s. All rights reserved.
//
//

import Foundation
import CoreData

extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")}

    @NSManaged public var name: String?
    @NSManaged public var studenttolesson: Lesson? //relashionship
}
