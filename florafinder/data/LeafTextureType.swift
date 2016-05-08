//
//  LeafTextureType.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData


class LeafTextureType: NSManagedObject {

    override var description: String
    {
        if (name != nil)
        {
            return "The top side of the leaf has a \(name!.lowercaseString) texture."
        }
        return ""
    }
}
