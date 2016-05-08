//
//  ServiceBase.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 9/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData

enum ServiceError: ErrorType {
    case DeletionError
    case RetrievalError
}

class Service<M: NSManagedObject> {

    var coreDataController: CoreDataController
    var entityName: NSString
    
    init(controller:CoreDataController, entityName: NSString)
    {
        self.coreDataController = controller
        self.entityName = entityName
    }

    func add() -> M
    {
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName(self.entityName as String,inManagedObjectContext: self.coreDataController.managedObjectContext) as! M
        return newEntity
    }
    
    func getObject(objectId: NSManagedObjectID) -> M?
    {
        return try? self.coreDataController.managedObjectContext.existingObjectWithID(objectId) as!M
    }
        
    func getObjects(predicate: NSPredicate?) -> [M]
    {
        return getObjects(predicate, sortDescriptors: nil)
    }
    
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [M]
    {
        do
        {
            let request = NSFetchRequest()
            let entity = NSEntityDescription.entityForName(self.entityName as String, inManagedObjectContext: self.coreDataController.managedObjectContext)
            request.entity = entity
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors
            
            return try self.coreDataController.managedObjectContext.executeFetchRequest(request) as! [M]
        }
        catch
        {
            //log
            return [M]()
        }
    }
    
    /**
     Returns all objects of the given type. If none exist and empty array is returned.
     */
    func getAll() -> [M]
    {
        return getObjects(nil, sortDescriptors: nil)
    }
    
    func deleteObject(object: M)
    {
        self.coreDataController.managedObjectContext.deleteObject(object)
    }
    
    func deleteAll() -> Int
    {
        var deleteCount = 0
        for object in getObjects(nil)
        {
            deleteObject(object)
            deleteCount += 1
        }
        return deleteCount
    }
    
    func save() throws
    {
        // somewhat misleading as managed objects aren't saved directly, but as part of a context save
        try self.coreDataController.save()
    }
}