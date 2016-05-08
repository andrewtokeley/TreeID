//
//  TestBase.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class TestBase: XCTestCase {

    lazy var serviceFactory: ServiceFactory = {
        return ServiceFactory.shareInstanceTesting
    }()
    
    lazy var leafTextureTypeService: LeafTextureTypeProtocol = {
        return self.serviceFactory.leafTextureTypeService
    }()
    
    lazy var floraService: FloraServiceProtocol = {
        return self.serviceFactory.floraService
    }()
    
    lazy var leafEdgeTypeService: LeafEdgeTypeProtocol = {
        return self.serviceFactory.leafEdgeTypeService
    }()
    
    lazy var leafFormationTypeService: LeafFormationTypeProtocol = {
        return self.serviceFactory.leafFormationTypeService
    }()
    
    lazy var leafService: LeafServiceProtocol = {
        return self.serviceFactory.leafService
    }()
    
    lazy var fruitColorTypeService: FruitColorTypeProtocol = {
        return self.serviceFactory.fruitColorTypeService
    }()
    
    lazy var leafColorTypeService: LeafColorTypeProtocol = {
        return self.serviceFactory.leafColorTypeService
    }()

    lazy var leafDimensionService: LeafDimensionProtocol = {
        return self.serviceFactory.leafDimensionService
    }()
    
    lazy var flowerColorTypeService: FlowerColorTypeProtocol = {
        return self.serviceFactory.flowerColorTypeService
    }()
    
    override func setUp() {
        super.setUp()
        
        do
        {
            // Each test should start with a clean database
            try self.serviceFactory.dataManagementService.rebuildDatabase()
        }
        catch
        {
            XCTFail()
        }
    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }

}
