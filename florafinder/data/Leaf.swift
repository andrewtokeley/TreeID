//
//  Leaf.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData


class Leaf: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    override var description: String
    {
        var sentences = [String]()
        
        if let text = notes { sentences.append(text) }
        if let text = dimensions?.description { sentences.append(text) }
        if let text = textureType?.description { sentences.append(text) }
        if let text = edgeType?.description { sentences.append(text) }
        if let text = formationType?.description { sentences.append(text) }
        
        return sentences.joinWithSeparator(" ")
    }
}
