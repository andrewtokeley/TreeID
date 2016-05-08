//
//  FruitColorTypeTests.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 15/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class FruitColorTypeTests: TestBase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCaseInsensitiveGetFromDatastore()
    {
        let color = fruitColorTypeService.getObject("RED")
        XCTAssertTrue(color?.name == "Red")
    }
    
    func testCaseInsensitiveToNameFromEnum()
    {
        if let redEnum = FruitColorTypeEnum.getByName("RED")
        {
            XCTAssertTrue(redEnum.rawValue == "Red")
        }
        else
        {
            XCTFail()
        }
    }
    
    func testSyncingEmptyDatabasePopulatesIt() {
        
        // Delete all FruitColorTypes from the datastore
        fruitColorTypeService.deleteAll()
        
        // Check they're all gone
        XCTAssertTrue(fruitColorTypeService.getAll().count == 0)

        fruitColorTypeService.syncEnumerationsToDatastore()
        
        XCTAssertTrue(fruitColorTypeService.getAll().count == FruitColorTypeEnum.allValues.count)
    }

    func testSyncAddsRecordToDatastoreIfMissing() {
        
        // remove one of the fruit colors from the datastore
        if let item = fruitColorTypeService.getObject(FruitColorTypeEnum.Black)
        {
            serviceFactory.coreDataController.managedObjectContext.deleteObject(item)
        }
        
        XCTAssertTrue(fruitColorTypeService.getAll().count == FruitColorTypeEnum.allValues.count - 1)
     
        fruitColorTypeService.syncEnumerationsToDatastore()
        
        XCTAssertTrue(fruitColorTypeService.getAll().count == FruitColorTypeEnum.allValues.count)
    }
    
    func testSyncRemovesRecordIfNotInEnumeration() {
        
        // add an extra record directly. This is something that should ever happen as the enumeration is the master copy of allowable records.
        
        // Bypass FruitColorTypeService to get access to add method - not intended to be used
        let directService = Service<FruitColorType>(controller: serviceFactory.coreDataController, entityName: "FruitColorType")
        let newType = directService.add()
        newType.name = "IShouldntBeHere"
        
        XCTAssertTrue(fruitColorTypeService.getAll().count == FruitColorTypeEnum.allValues.count + 1)
        
        fruitColorTypeService.syncEnumerationsToDatastore()
        
        XCTAssertTrue(fruitColorTypeService.getAll().count == FruitColorTypeEnum.allValues.count)
    }
    
    func testSyncUpdatesExistingRecordsInDatastore()
    {
        if let existingType = fruitColorTypeService.getObject(FruitColorTypeEnum.Green)
        {
            // shouldn't ever do this directly, sync will revert
            existingType.order = 1000
            existingType.color = UIColor.cyanColor()
            
            XCTAssertFalse(existingType.order == FruitColorTypeEnum.Green.order())
            XCTAssertFalse(existingType.color!.isEqual(FruitColorTypeEnum.Green.color()))
            
            fruitColorTypeService.syncEnumerationsToDatastore()
            
            XCTAssertTrue(existingType.order == FruitColorTypeEnum.Green.order())
            XCTAssertTrue(existingType.color!.isEqual(FruitColorTypeEnum.Green.color()))

        }
        else
        {
            XCTFail()
        }
    }
}
