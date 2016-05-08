//
//  LeafTextureTypeService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum LeafTextureTypeEnum: String
{
    case Smooth = "Smooth"
    case Hairy = "Hairy"
    case Rough = "Rough"
    case Scratchy = "Scratchy"
    case Waxy = "Waxy"
    case Spotted = "Spotted"
    case Soft = "Soft"
    
    static let allValues = [Soft, Smooth, Hairy, Rough, Scratchy, Waxy, Spotted]
    
    static func getByName(name: String) -> LeafTextureTypeEnum?
    {
        return LeafTextureTypeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
    }

    func order() -> Int
    {
        return LeafTextureTypeEnum.allValues.indexOf(self)!
    }
}

class LeafTextureTypeService: EnumService<LeafTextureType>, EnumServiceDelegate, LeafTextureTypeProtocol {
    
    //MARK: - Initialisers
    
    override init(controller: CoreDataController, entityName: NSString) {
        super.init(controller: controller, entityName: entityName)
        
        // Must set the EnumService delegate here so that syncEnumerations gets called on initialisation
        delegate = self
        
    }

    //MARK: - Syncing
    
    /**
     Ensures the enumerations and records in the datastore are the same
     */
    internal func syncEnumerationsToDatastore()
    {
        // Add missing or update existing records to datastore
        for enumeration in LeafTextureTypeEnum.allValues
        {
            // Ignore errors for now
            let _ = try? addOrUpdate(enumeration)
        }
        
        // find out if there are any datastore entries that are no longer defined in the enumerator
        for data in getAll()
        {
            if let typeName = data.name
            {
                if (LeafTextureTypeEnum(rawValue: typeName) == nil)
                {
                    // The record in the datastore doesn't match any enum so remove it (if you can)
                    do
                    {
                        try data.validateForDelete()
                        
                        coreDataController.managedObjectContext.deleteObject(data)
                    }
                    catch
                    {
                        // LOG - probaby not fatal, just means the user will have to change this property to something else if editing.
                    }
                }
                //
            }
        }
    }
    
    func reset()
    {
        super.resetDatastore()
    }
    
    private func addOrUpdate(type: LeafTextureTypeEnum) throws -> LeafTextureType
    {
        if let existing = getObject(type.rawValue)
        {
            existing.order = type.order()
            
            try save()
            
            return existing
        }
        else
        {
            let new = add()
            new.name = type.rawValue
            new.order = type.order()
            
            try save()
            
            return new
        }
    }
    
    //MARK: - Get
    
    override func getAll() -> [LeafTextureType] {
        let sort = NSSortDescriptor(key: "order", ascending: true)
        return super.getObjects(nil, sortDescriptors: [sort])
    }
    override func getObjects(predicate: NSPredicate?) -> [LeafTextureType] {
        return super.getObjects(predicate)
    }
    override func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafTextureType] {
        return super.getObjects(predicate, sortDescriptors: sortDescriptors)
    }
    func getObject(name: String) -> LeafTextureType?
    {
        return super.getObjects(NSPredicate(format: "name ==[c] %@", name)).first
    }
    func getObject(type: LeafTextureTypeEnum) -> LeafTextureType?
    {
        return getObject(type.rawValue)
    }
}