//
//  Leaf+CoreDataProperties.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 3/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Leaf {

    @NSManaged var notes: String?
    @NSManaged var colorType: LeafColorType?
    @NSManaged var dimensions: LeafDimension?
    @NSManaged var edgeType: LeafEdgeType?
    @NSManaged var flora: Flora?
    @NSManaged var formationType: LeafFormationType?
    @NSManaged var textureType: LeafTextureType?

}
