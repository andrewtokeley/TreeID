//
//  LeafEdgeType.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData


class LeafEdgeType: NSManagedObject
{

    override var description: String
    {
        if (name != nil)
        {
            return "The edges of the leaf are \(name!.lowercaseString)."
        }
        return ""
    }

}
