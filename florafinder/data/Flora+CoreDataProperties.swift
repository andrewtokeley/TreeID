//
//  Flora+CoreDataProperties.swift
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

extension Flora {

    @NSManaged var commonName: String?
    @NSManaged var externalURL: String?
    @NSManaged var imagePath: String?
    @NSManaged var notes: String?
    @NSManaged var bark: Bark?
    @NSManaged var flowerColor: FlowerColorType?
    @NSManaged var fruitColor: FruitColorType?
    @NSManaged var leafUpper: Leaf?

}
