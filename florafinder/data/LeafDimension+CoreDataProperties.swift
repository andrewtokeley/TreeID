//
//  LeafDimension+CoreDataProperties.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 18/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LeafDimension {

    @NSManaged var widthMax: NSNumber?
    @NSManaged var widthMin: NSNumber?
    @NSManaged var lengthMax: NSNumber?
    @NSManaged var lengthMin: NSNumber?
    @NSManaged var leaf: Leaf?

}
