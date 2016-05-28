//
//  LeafDimension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData


class LeafDimension: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    override var description: String
    {
        if (maximumSize != nil && minimumSize != nil)
        {            
            return "Leaves are \(minimumSize!.descriptionWithOtherMeasure(maximumSize!))."
        }
        return ""
    }
    
    var shape: LeafShapeEnum?
    {
        return maximumSize?.shape
    }
    
    var ratio: Float
    {
        return maximumSize?.ratio ?? 0
    }
    
    var minimumSize: Measurement?
    {
        if (widthMin != nil && lengthMin != nil)
        {
            return Measurement(width: (widthMin?.floatValue)!, length: (lengthMin?.floatValue)!)
        }
        else
        {
            return nil
        }
    }
    
    var maximumSize: Measurement?
    {
        if (widthMax != nil && lengthMax != nil)
        {
            return Measurement(width: (widthMax?.floatValue)!, length: (lengthMax?.floatValue)!)
        }
        else
        {
            return nil
        }
    }
    
    
}
