//
//  Bark+CoreDataProperties.swift
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

extension Bark {

    @NSManaged var flora: NSSet?
    @NSManaged var textureType: BarkTextureType?

}
