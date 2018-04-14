//
//  CoreDataModelable.swift
//  CoreDataDemo
//
//  Created by Jatin on 14/04/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import Foundation
import CoreData

@objc protocol CoreDataModelable: class {
    static var entityName: String { get }
}

extension CoreDataModelable where Self: NSManagedObject {
    
    /**
     This method checks if the object is already registered in the context and subsequently returns that object
     Hence, saving us a round-trip to the DB in form of a fetch request
     **/
    
    static func findOrFetch(in context: NSManagedObjectContext,
                                   matching predicate: NSPredicate) -> Self? {
        
        guard let object = materializedObject(in: context, matching: predicate) else {
            let objects = fetch(in: context) { request in
                request.fetchLimit = 1
                request.returnsObjectsAsFaults = false
                request.predicate = predicate
            }
            return objects?.first
        }
        
        return object
    }
    
    static func materializedObject(in context: NSManagedObjectContext,
                                          matching predicate: NSPredicate) -> Self? {
        
        for object in context.registeredObjects where !object.isFault {
            guard let object = object as? Self, predicate.evaluate(with: object) else {
                continue
            }
            return object
        }
        
        return nil
    }
    
    static func fetch(in context: NSManagedObjectContext,
                             configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }) -> [Self]? {
        
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        do {
            return try context.fetch(request)
        } catch {
            assertionFailure("Could not fetch the entity = \(Self.entityName)")
            return nil
        }
        
    }
    
}
