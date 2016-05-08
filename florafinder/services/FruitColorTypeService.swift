//
//  FruitColorTypeService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 29/02/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum FruitColorTypeEnum: String
{
    case Green = "Green"
    case Purple = "Purple"
    case Orange = "Orange"
    case Black = "Black"
    case Pink = "Pink"
    case Red = "Red"
    case Blue = "Blue"
    case Yellow = "Yellow"
    case DarkRed = "Dark Red"
    
    static let allValues = [Pink, Green, Purple, Orange, Yellow, Black, Red, DarkRed, Blue]

    static func getByName(name: String) -> FruitColorTypeEnum?
    {
        return FruitColorTypeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
    }
    
    func order() -> Int
    {
        return FruitColorTypeEnum.allValues.indexOf(self)!
    }
    
    func color() -> UIColor
    {
        switch self {
            case .Green: return UIColor.fruitGreen()
            case .Purple: return UIColor.fruitPurple()
            case .Orange: return UIColor.fruitOrange()
            case .Black: return UIColor.blackColor()
            case .Pink: return UIColor.fruitPink()
            case .Red: return UIColor.fruitRed()
            case .Blue: return UIColor.fruitLightBlue()
            case .Yellow: return UIColor.fruitYellow()
            case .DarkRed: return UIColor.fruitDarkRed()
        }
    }
}

class FruitColorTypeService: EnumService<FruitColorType>, EnumServiceDelegate, FruitColorTypeProtocol {
    
    //MARK: - Initialiser
    
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
        for enumeraton in FruitColorTypeEnum.allValues
        {
            // Ignore errors for now
            let _ = try? addOrUpdate(enumeraton)
        }
        
        // find out if there are any datastore entries that are no longer defined in the enumerator
        for data in getAll()
        {
            if let typeName = data.name
            {
                if (FruitColorTypeEnum(rawValue: typeName) == nil)
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
    
    private func addOrUpdate(type: FruitColorTypeEnum) throws -> FruitColorType
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

    //MARK: - Set up
    
    func getObject(name: String) -> FruitColorType?
    {
        return super.getObjects(NSPredicate(format: "name ==[c] %@", name)).first
    }
    
    func getObject(type: FruitColorTypeEnum) -> FruitColorType?
    {
        return getObject(type.rawValue.lowercaseString)
    }
    
    
    //MARK: - Protocol Overriders

    override func getAll() -> [FruitColorType] {
        let sort = NSSortDescriptor(key: "order", ascending: true)
        return super.getObjects(nil, sortDescriptors: [sort])
    }
    override func getObjects(predicate: NSPredicate?) -> [FruitColorType] {
        return super.getObjects(predicate)
    }
    override func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [FruitColorType] {
        return super.getObjects(predicate, sortDescriptors: sortDescriptors)
    }
    override func deleteAll() -> Int {
        return super.deleteAll()
    }
    
}