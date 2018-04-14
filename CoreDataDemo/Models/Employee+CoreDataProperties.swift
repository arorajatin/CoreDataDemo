//
//  Employee+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Jatin on 14/04/18.
//  Copyright © 2018 Jatin. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var name: String
    @NSManaged public var amazing: Bool
    @NSManaged public var score: Int64
    @NSManaged public var department: Department?

}
