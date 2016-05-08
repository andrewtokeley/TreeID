//
//  LeafColorTypeService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation


enum LeafColorTypeEnum: String
{
    case VeryDarkGreen = "Very Dark Green"
    case DarkGreen = "Dark Green"
    case Green = "Green"
    case LightGreen = "Light Green"
    case MultiColored = "Multi-Colored"
    
    static let allValues = [VeryDarkGreen, DarkGreen, Green, LightGreen, MultiColored]
    
    static func getByName(name: String) -> LeafColorTypeEnum?
    {
        return LeafColorTypeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
    }
    
    func order() -> Int
    {
        return LeafColorTypeEnum.allValues.indexOf(self)!
    }
    
    func color() -> UIColor
    {
        switch self {
            case .VeryDarkGreen: return UIColor.leafVeryDarkGreen()
            case .DarkGreen: return UIColor.leafDarkGreen()
            case .Green: return UIColor.leafGreen()
            case .LightGreen: return UIColor.leafLightGreen()
            case .MultiColored: return UIColor.leafVeryDarkGreen()
        }
    }
}

class LeafColorTypeService: EnumService<LeafColorType>, EnumServiceDelegate, LeafColorTypeProtocol {
    
    //MARK: Initialisers
    override init(controller: CoreDataController, entityName: NSString) {
        super.init(controller: controller, entityName: entityName)
        
        // Must set the EnumService delegate here so that syncEnumerations gets called on initialisation
        delegate = self
    }
    
    //MARK: - Syncing
    
    /**
     Ensures the enumerations and records in the datastore are the same
     */
    func syncEnumerationsToDatastore()
    {
        // Add missing or update existing records to datastore
        for enumeration in LeafColorTypeEnum.allValues
        {
            // Ignore errors for now
            let _ = try? addOrUpdate(enumeration)
        }
        
        // find out if there are any datastore entries that are no longer defined in the enumerator
        for data in getAll()
        {
            if let typeName = data.name
            {
                if (LeafColorTypeEnum(rawValue: typeName) == nil)
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
    
    private func addOrUpdate(type: LeafColorTypeEnum) throws -> LeafColorType
    {
        if let existing = getObject(type.rawValue)
        {
            existing.order = type.order()
            existing.color = type.color()
            
            try save()
            
            return existing
        }
        else
        {
            let new = add()
            new.name = type.rawValue
            new.color = type.color()
            new.order = type.order()
            
            try save()
            
            return new
        }
    }
    
    //MARK: - Service Overrides
    
    override func getAll() -> [LeafColorType]
    {
        // sort by order ascending
        let sort = NSSortDescriptor(key: "order", ascending: true)
        return super.getObjects(nil, sortDescriptors: [sort])
    }
    override func getObjects(predicate: NSPredicate?) -> [LeafColorType] {
        return super.getObjects(predicate)
    }
    override func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafColorType] {
        return super.getObjects(predicate, sortDescriptors: sortDescriptors)
    }
    func getObject(name: String) -> LeafColorType?
    {
        return super.getObjects(NSPredicate(format: "name ==[c] %@", name)).first
    }
    func getObject(type: LeafColorTypeEnum) -> LeafColorType?
    {
        return getObject(type.rawValue)
    }

}