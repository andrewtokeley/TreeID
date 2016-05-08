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
    
    override var description: String
    {
        if (maximumSize != nil && minimumSize != nil)
        {
            return "Leaves are \(minimumSize!.description)cm wide and \(maximumSize!.description)cm long."
        }
        return ""
    }
}
