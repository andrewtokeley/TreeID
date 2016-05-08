//
//  EnumService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 15/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData

protocol EnumServiceDelegate
{
    func syncEnumerationsToDatastore()
}

class EnumService<M: NSManagedObject>: Service<M>
{
    var delegate: EnumServiceDelegate?
    {
        didSet
        {
            // Whenever a delegate is set we synchronise
            delegate?.syncEnumerationsToDatastore()
        }
    }
    
    override init(controller: CoreDataController, entityName: NSString) {
        super.init(controller: controller, entityName: entityName)
    }
    
    /**
     Removes all records from the datastore and add records for each enumeration
    */
    func resetDatastore()
    {
        deleteAll()
        delegate?.syncEnumerationsToDatastore()
    }
    
}