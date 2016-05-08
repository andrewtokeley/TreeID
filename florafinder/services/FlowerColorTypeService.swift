//
//  FlowerColorTypeService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 13/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum FlowerColorTypeEnum: String
{
    case Red = "Red"
    case Pink = "Pink"
    case Yellow = "Yellow"
    case White = "White"
    case Purple = "Purple"
    
    static let allValues = [Red, Pink, Yellow, White, Purple]
    
    static func getByName(name: String) -> FlowerColorTypeEnum?
    {
        return FlowerColorTypeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
    }
    
    func order() -> Int
    {
        return FlowerColorTypeEnum.allValues.indexOf(self)!
    }
    
    func color() -> UIColor
    {
        switch self {
        case .Red: return UIColor.flowerRed()
        case .Yellow: return UIColor.flowerYellow()
        case .White: return UIColor.flowerWhite()
        case .Purple: return UIColor.purpleColor()
        case .Pink: return UIColor.flowerPink()
        }
    }
}

class FlowerColorTypeService: EnumService<FlowerColorType>, EnumServiceDelegate, FlowerColorTypeProtocol
{
    //MARK: - Inititialisers
    
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
        for enumeration in FlowerColorTypeEnum.allValues
        {
            // Ignore errors for now
            let _ = try? addOrUpdate(enumeration)
        }
        
        // find out if there are any datastore entries that are no longer defined in the enumerator
        for data in getAll()
        {
            if let typeName = data.name
            {
                if (FlowerColorTypeEnum(rawValue: typeName) == nil)
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
    
    private func addOrUpdate(type: FlowerColorTypeEnum) throws -> FlowerColorType
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
    
    //MARK: - Protocol Methods
    
    func getObject(name: String) -> FlowerColorType?
    {
        return super.getObjects(NSPredicate(format: "name ==[c] %@", name)).first
    }
    
    func getObject(type: FlowerColorTypeEnum) -> FlowerColorType?
    {
        return getObject(type.rawValue.lowercaseString)
    }
    
    //MARK: - Protocol Overrides
    
    override func getAll() -> [FlowerColorType] {
        let sort = NSSortDescriptor(key: "order", ascending: true)
        return super.getObjects(nil, sortDescriptors: [sort])
    }
    
    override func getObjects(predicate: NSPredicate?) -> [FlowerColorType] {
        return super.getObjects(predicate)
    }
    override func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [FlowerColorType] {
        return super.getObjects(predicate, sortDescriptors: sortDescriptors)
    }
    override func deleteAll() -> Int {
        return super.deleteAll()
    }
}