//
//  ServiceFactory.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 12/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum RunModeEnum
{
    case Test
    case Run
}

enum ServiceFactoryError: ErrorType
{
    case ServiceInitializationFailed
}

class ServiceFactory {
    
    var runMode: RunModeEnum
    
    init(mode: RunModeEnum)
    {
        runMode = mode
    }
    
    static var shareInstance: ServiceFactory =
    {
        return ServiceFactory(mode: RunModeEnum.Run)
    }()
    
    static var shareInstanceTesting: ServiceFactory =
    {
        return ServiceFactory(mode: RunModeEnum.Test)
    }()

    lazy var coreDataController: CoreDataController = {
        do
        {
            if (self.runMode == RunModeEnum.Run)
            {
                return try CoreDataController(dataModelName: "Model", storeName: "Run")
            }
            else
            {
                return try CoreDataController(dataModelName: "Model", storeName: "Test")
            }
        }
        catch
        {
            fatalError("Can't run tests if the CareDataController can't be initiated")
        }
    }()
    
    lazy var fruitColorTypeService: FruitColorTypeProtocol = {
        return FruitColorTypeService(controller: self.coreDataController, entityName: "FruitColorType")
    }()
    
    lazy var leafColorTypeService: LeafColorTypeProtocol = {
        return LeafColorTypeService(controller: self.coreDataController, entityName: "LeafColorType")
    }()
    
    lazy var leafTextureTypeService: LeafTextureTypeProtocol = {
       return LeafTextureTypeService(controller: self.coreDataController, entityName: "LeafTextureType")
    }()
    
    lazy var leafEdgeTypeService: LeafEdgeTypeProtocol = {
        return LeafEdgeTypeService(controller: self.coreDataController, entityName: "LeafEdgeType")
    }()
    
    lazy var floraService: FloraServiceProtocol = {
        return FloraService(controller: self.coreDataController, entityName: "Flora")
    }()
    
    lazy var leafService: LeafServiceProtocol = {
        return LeafService(controller: self.coreDataController, entityName: "Leaf")
    }()
    
    lazy var flowerColorTypeService: FlowerColorTypeProtocol = {
        return FlowerColorTypeService(controller: self.coreDataController, entityName: "FlowerColorType")
    }()
    
    lazy var dataManagementService: DataManagerServiceProtocol = {
        return DataManagerService(serviceFactory: self)
    }()
   
    lazy var leafFormationTypeService: LeafFormationTypeProtocol = {
        return LeafFormationTypeService(controller: self.coreDataController, entityName: "LeafFormationType")
    }()
    
    lazy var leafDimensionService: LeafDimensionProtocol = {
        return LeafDimensionService(controller: self.coreDataController, entityName: "LeafDimension")
    }()

    lazy var imageCacheProvider: DataStoreProviderProtocol? = {
        if let service = try? CacheDataStoreProvider(storeName: "ImageCache")
        {
            return service
        }
        //throw ServiceFactoryError.ServiceInitializationFailed
        return nil
    }()
    
    lazy var imageDataProvider: DataStoreProviderProtocol? = {
//        if let service = try? LocalDataStoreProvider(storeName: "ImageStore")
//        {
//            return service
//        }
//        return nil
        return BundleDataStoreProvider()
    }()
    
    lazy var imageService: ImageService = {
        return ImageService(cacheDataStoreProvider: self.imageCacheProvider!, masterDataStoreProvider: self.imageDataProvider!)
    }()
}