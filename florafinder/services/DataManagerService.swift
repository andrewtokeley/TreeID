//
//  DataManagerService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 14/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class DataManagerService: DataManagerServiceProtocol
{
    var serviceFactory:ServiceFactory!
    
    init(serviceFactory:ServiceFactory)
    {
        self.serviceFactory = serviceFactory
    }
    
    func rebuildDatabase() throws
    {
        // completely blow away the datastore and recreate an empty one
        try serviceFactory.coreDataController.resetDatastore()
        
        serviceFactory.flowerColorTypeService.syncEnumerationsToDatastore()
        serviceFactory.fruitColorTypeService.syncEnumerationsToDatastore()
        serviceFactory.leafColorTypeService.syncEnumerationsToDatastore()
        serviceFactory.leafTextureTypeService.syncEnumerationsToDatastore()
        serviceFactory.leafEdgeTypeService.syncEnumerationsToDatastore()
        serviceFactory.leafFormationTypeService.syncEnumerationsToDatastore()
        
    }
}