//
//  LeafEdgeTypeService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum LeafEdgeTypeEnum: String
{
    case Smooth = "Smooth"
    case Serrated = "Serrated"
    case Rippled = "Rippled"
    
    static let allValues = [Smooth, Serrated, Rippled]
    
    static func getByName(name: String) -> LeafEdgeTypeEnum?
    {
        return LeafEdgeTypeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
    }
    
    func order() -> Int
    {
        return LeafEdgeTypeEnum.allValues.indexOf(self)!
    }
    
    func image() -> UIImage
    {
        switch self {
        case .Smooth: return UIImage(named: "smooth.png")!.changeColor(UIColor.leafDarkGreen())!
        case .Serrated: return UIImage(named: "serrated.png")!.changeColor(UIColor.leafDarkGreen())!
        case .Rippled: return UIImage(named: "wrinkled.png")!.changeColor(UIColor.leafDarkGreen())!
        }
    }
}

class LeafEdgeTypeService: EnumService<LeafEdgeType>, EnumServiceDelegate, LeafEdgeTypeProtocol
{
    
    override init(controller: CoreDataController, entityName: NSString)
    {
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
        for enumeration in LeafEdgeTypeEnum.allValues
        {
            // Ignore errors for now
            let _ = try? addOrUpdate(enumeration)
        }
        
        // find out if there are any datastore entries that are no longer defined in the enumerator
        for data in getAll()
        {
            if let typeName = data.name
            {
                if (LeafEdgeTypeEnum(rawValue: typeName) == nil)
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
    
    private func addOrUpdate(type: LeafEdgeTypeEnum) throws -> LeafEdgeType
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
    
    //MARK: - Protocol methods

    override func getAll() -> [LeafEdgeType]
    {
        let sort = NSSortDescriptor(key: "order", ascending: true)
        return super.getObjects(nil, sortDescriptors: [sort])
    }
    override func getObjects(predicate: NSPredicate?) -> [LeafEdgeType]
    {
        return super.getObjects(predicate)
    }
    override func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafEdgeType]
    {
        return super.getObjects(predicate, sortDescriptors: sortDescriptors)
    }
    override func deleteAll() -> Int
    {
        return super.deleteAll()
    }
    func getObject(name: String) -> LeafEdgeType?
    {
        return super.getObjects(NSPredicate(format: "name ==[c] %@", name)).first
    }
    func getObject(type: LeafEdgeTypeEnum) -> LeafEdgeType?
    {
        return getObject(type.rawValue)
    }
}