//
//  LeafFormationTypeService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 18/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum LeafFormationTypeEnum: String
{
    case Paired = "Paired"
    case Alternate = "Alternate"
    case Star = "Star"
    case Cluster = "Compound"
    
    static let allValues = [Paired, Alternate, Star, Cluster]
    
    func image() -> UIImage
    {
        switch self
        {
            case .Paired: return UIImage(named: "individual")!.changeColor(UIColor.leafDarkGreen())!
            case .Alternate: return UIImage(named: "alternating.png")!.changeColor(UIColor.leafDarkGreen())!
            case .Star: return UIImage(named: "star.png")!.changeColor(UIColor.leafDarkGreen())!
            case .Cluster: return UIImage(named: "cluster.png")!.changeColor(UIColor.leafDarkGreen())!
        }
    }
    
    static func getByName(name: String) -> LeafFormationTypeEnum?
    {
        return LeafFormationTypeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
    }
    
    func order() -> Int
    {
        return LeafFormationTypeEnum.allValues.indexOf(self)!
    }
}

class LeafFormationTypeService: EnumService<LeafFormationType>, EnumServiceDelegate, LeafFormationTypeProtocol {
    
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
        for enumeration in LeafFormationTypeEnum.allValues
        {
            // Ignore errors for now
            let _ = try? addOrUpdate(enumeration)
        }
        
        // find out if there are any datastore entries that are no longer defined in the enumerator
        for data in getAll()
        {
            if let typeName = data.name
            {
                if (LeafFormationTypeEnum(rawValue: typeName) == nil)
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
    
    private func addOrUpdate(type: LeafFormationTypeEnum) throws -> LeafFormationType
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
    
    override func getAll() -> [LeafFormationType] {
        let sort = NSSortDescriptor(key: "order", ascending: true)
        return super.getObjects(nil, sortDescriptors: [sort])
    }
    override func getObjects(predicate: NSPredicate?) -> [LeafFormationType] {
        return super.getObjects(predicate)
    }
    override func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafFormationType] {
        return super.getObjects(predicate, sortDescriptors: sortDescriptors)
    }
    func getObject(name: String) -> LeafFormationType?
    {
        return super.getObjects(NSPredicate(format: "name ==[c] %@", name)).first
    }
    func getObject(type: LeafFormationTypeEnum) -> LeafFormationType?
    {
        return getObject(type.rawValue)
    }
    
}