//
//  floraImporter.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 31/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class FloraImporter: TOKCSVParser
{
    var serviceFactory: ServiceFactory!

    convenience init(serviceFactory: ServiceFactory, fileURL: NSURL)
    {
        self.init(fileURL: fileURL)
        self.serviceFactory = serviceFactory
    }
    
    //MARK: Column Definitions
    override var columnDefinitions: [AnyObject]!
    {
        return [commonNameColumn,
                notesColumn,
                leafMinWidthColumn,
                leafMaxWidthColumn,
                leafMinLengthColumn,
                leafMaxLengthColumn,
                leafColorColumn,
                leafFormationColumn,
                flowerColorColumn,
                fruitColorColumn,
                leafTextureColumn,
                leafEdgeColumn,
                externalURLColumn,
                imageColumn,
                leafNotesColumn]
    }
    
    lazy var commonNameColumn: TOKCSVColumnDefinition =
        {
            let column = TOKCSVColumnDefinition(heading: "CommonName", mandatory: true)
            return column
    }()
    
    lazy var imageColumn: TOKCSVColumnDefinition =
        {
            let column = TOKCSVColumnDefinition(heading: "Image", mandatory: false)
            return column
    }()
    
    lazy var leafNotesColumn: TOKCSVColumnDefinition =
        {
            let column = TOKCSVColumnDefinition(heading: "LeafNotes", mandatory: false)
            return column
    }()
    
    lazy var notesColumn: TOKCSVColumnDefinition =
        {
            let column = TOKCSVColumnDefinition(heading: "Notes", mandatory: false)
            return column
    }()
    
    lazy var externalURLColumn: TOKCSVColumnDefinition =
        {
            let column = TOKCSVColumnDefinition(heading: "ExternalURL", mandatory: false)
            
            column.valueFromField =
                {
                    field in
                    
                    if (column.isValidField(field))
                    {
                        return field == "" ? nil : field // NSURL(string: field)!
                    }
                    return nil
            }
            
            column.isValidField =
                {
                    field in
                    
                    if (field == nil || field == "")
                    {
                        return true
                    }
                    
                    if let url = NSURL(string: field)
                    {
                        return UIApplication.sharedApplication().canOpenURL(url)
                    }
                    return false
            }
            
            return column
    }()
    
    lazy var leafMinWidthColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "LeafMinWidth", mandatory: false)
        
        column.valueFromField =
            {
                field in
                return self.readDecimal(field)
        }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || self.readDecimal(field) != nil
        }
        
        return column
    }()

    lazy var leafMaxWidthColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "LeafMaxWidth", mandatory: false)
        column.valueFromField = { field in return self.readDecimal(field) }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || self.readDecimal(field) != nil
        }

        return column
    }()

    lazy var leafMinLengthColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "LeafMinLength", mandatory: false)
        column.valueFromField =
            {
                field in return self.readDecimal(field)
        }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || self.readDecimal(field) != nil
        }

        return column
    }()
    
    lazy var leafMaxLengthColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "LeafMaxLength", mandatory: false)
        column.valueFromField = { field in return self.readDecimal(field) }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || self.readDecimal(field) != nil
        }

        return column
    }()

    lazy var leafEdgeColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "LeafEdge", mandatory: false)
        
        column.valueFromField =
            {
                field in
                if (column.isValidField(field))
                {
                    return self.serviceFactory.leafEdgeTypeService.getObject(field)
                }
                return nil
        }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || LeafEdgeTypeEnum.getByName(field) != nil
        }
        
        column.fieldFromData = {
            data in
            
            if let type = data as? LeafTextureType
            {
                return type.name
            }
            else
            {
                return nil
            }
        }
        
        return column
    }()
    
    lazy var leafTextureColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "LeafTexture", mandatory: false)
        
        column.valueFromField =
            {
                field in
                if (column.isValidField(field))
                {
                    return self.serviceFactory.leafTextureTypeService.getObject(field)
                }
                return nil
        }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || LeafTextureTypeEnum.getByName(field) != nil
        }
        
        column.fieldFromData = {
            data in
            
            if let type = data as? LeafTextureType
            {
                return type.name
            }
            else
            {
                return nil
            }
        }
        
        return column
    }()

    lazy var leafFormationColumn: TOKCSVColumnDefinition =
        {
            let column = TOKCSVColumnDefinition(heading: "LeafFormation", mandatory: false)
            
            column.valueFromField =
                {
                    field in
                    if (column.isValidField(field))
                    {
                        return self.serviceFactory.leafFormationTypeService.getObject(field)
                    }
                    return nil
            }
            
            column.isValidField =
                {
                    field in
                    return field == nil || field == "" || LeafFormationTypeEnum.getByName(field) != nil
            }
            
            column.fieldFromData = {
                data in
                
                if let type = data as? LeafFormationType
                {
                    return type.name
                }
                else
                {
                    return nil
                }
            }
            
            return column
    }()
    
    lazy var flowerColorColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "FlowerColor", mandatory: false)
        
        column.valueFromField =
        {
            field in
            if (column.isValidField(field))
            {
                return self.serviceFactory.flowerColorTypeService.getObject(field)
            }
            return nil
        }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || FlowerColorTypeEnum.getByName(field) != nil
        }
        
        column.fieldFromData = {
            data in
            
            if let type = data as? FlowerColorType
            {
                return type.name
            }
            else
            {
                return nil
            }
        }
        
        return column
    }()

    lazy var fruitColorColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "FruitColor", mandatory: false)
        
        column.valueFromField =
            {
                field in
                
                if (column.isValidField(field))
                {
                    return self.serviceFactory.fruitColorTypeService.getObject(field)
                }
                return nil
        }
        
        column.isValidField =
            {
                field in
                return field == nil || field == "" || FruitColorTypeEnum.getByName(field) != nil
        }
        
        column.fieldFromData = {
            data in
            
            if let type = data as? FruitColorType
            {
                return type.name
            }
            else
            {
                return nil
            }
        }
        
        return column
    }()

    lazy var leafColorColumn: TOKCSVColumnDefinition =
    {
        let column = TOKCSVColumnDefinition(heading: "LeafColor", mandatory: false)
        
        column.valueFromField =
            {
                field in
                
                if (column.isValidField(field))
                {
                    return self.serviceFactory.leafColorTypeService.getObject(field)
                }
                return nil
        }
        
        column.isValidField =
            {
                field in

                return field == nil || field == "" || LeafColorTypeEnum.getByName(field) != nil
        }
        
        column.fieldFromData = {
            data in
            
            if let type = data as? FruitColorType
            {
                return type.name
            }
            else
            {
                return nil
            }
        }
        
        
        return column
    }()

    //MARK: Helpers
    
    func readDecimal(field: String) -> Float?
    {
        var result: Float?
        if (field.characters.count > 0)
        {
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            result = formatter.numberFromString(field) as? Float
        }
        return result;
    }
    
    //MARK: Import
    
    override func processRowData(data: [NSObject : AnyObject]!, recordNumber: UInt, save: Bool) -> AnyObject!
    {
        var flora:Flora?
        
        // retrieve each data element from the row - can ensure this field can be converted to TOKRowField since it's mandatory
        let commonNameField = data["CommonName"] as! TOKRowField
       
        if (commonNameField.rawData == "Northern Rata")
        {
            print("hi")
        }

        let leafMinWidth = data["LeafMinWidth"]
        let leafMaxWidth = data["LeafMaxWidth"]
        let leafMinLength = data["LeafMinLength"]
        let leafMaxLength = data["LeafMaxLength"]
        let flowerColor = data["FlowerColor"]
        let fruitColor = data["FruitColor"]
        let leafColor = data["LeafColor"]
        let edgeType = data["LeafEdge"]
        let formationType = data["LeafFormation"]
        let leafTexture = data["LeafTexture"]
        let externalURL = data["ExternalURL"]
        let image = data["Image"]
        let leafNotes = data["LeafNotes"]
        let notes = data["Notes"]
        
        // Check if flora exists already, if not create one
        flora = serviceFactory.floraService.getObject(commonNameField.transformedData as! String)
        
        if (flora == nil)
        {
            self.validationMessages.addMessage(TOKImportMessage(message: "New flora - '\(commonNameField.transformedData)'", severity: TOKImportMessageSeverity.Information))
            
            // Add entities to datastore
            if (save)
            {
                // Add flora
                flora = serviceFactory.floraService.addFlora(commonNameField.transformedData as! String)
                
                // Add leaf (actual values will be set below)
                let leafDimensions = serviceFactory.leafDimensionService.addLeafDimension(Measurement(width: 0,length: 0))                
                flora?.leafUpper = serviceFactory.leafService.addLeaf(leafDimensions, edge: nil, color: nil, texture: nil)
            }
        }
        else
        {
            self.validationMessages.addMessage(TOKImportMessage(message: "Update flora \(flora?.commonName!)", severity: TOKImportMessageSeverity.Information))
        }
        
        // Only update the entity if we're saving
        if (save)
        {
            flora?.leafUpper?.dimensions?.widthMin = leafMinWidth?.transformedData as? Float
            flora?.leafUpper?.dimensions?.widthMax = leafMaxWidth?.transformedData as? Float
            flora?.leafUpper?.dimensions?.lengthMin = leafMinLength?.transformedData as? Float
            flora?.leafUpper?.dimensions?.lengthMax = leafMaxLength?.transformedData as? Float
            flora?.leafUpper?.textureType = leafTexture?.transformedData as? LeafTextureType
            flora?.leafUpper?.colorType = leafColor?.transformedData as? LeafColorType
            flora?.leafUpper?.edgeType = edgeType?.transformedData as? LeafEdgeType
            flora?.leafUpper?.formationType = formationType?.transformedData as? LeafFormationType
            flora?.leafUpper?.notes = leafNotes?.transformedData as? String
            flora?.flowerColor = flowerColor?.transformedData as? FlowerColorType
            flora?.fruitColor = fruitColor?.transformedData as? FruitColorType
            flora?.externalURL = externalURL?.transformedData as? String
            flora?.imagePath = image?.transformedData as? String
            flora?.notes = notes?.transformedData as? String
            
//            if let image = UIImage(named: "fivefinger_main.jpg")
//            {
//                serviceFactory.imageDataProvider?.uploadImage(image, relativePath: "fivefinger_main.jpg")
//            }
            do
            {
                try self.serviceFactory.coreDataController.save()
            }
            catch
            {
                // TODO: Logger
                self.validationMessages.addMessage(TOKImportMessage(message: "Failed to save row \(recordNumber), \(flora?.commonName)", severity: TOKImportMessageSeverity.FatalError))
            }
        }
        return flora
    }
}