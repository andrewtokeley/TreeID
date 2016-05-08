//
//  florafinderTests.swift
//  florafinderTests
//
//  Created by Andrew Tokeley  on 2/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class floraTests: TestBase {
    
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        self.serviceFactory.coreDataController.rollback()
    }
    
    func testAddFloraWithLeafDimensions()
    {
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 0.1, length: 10), maximumSize: Measurement(width: 0.2, length: 12))
        
        let leaf = leafService.addLeaf(dimension, edge: nil, color: nil, texture: nil)
        let _ = floraService.addFlora("tree", leafUpper: leaf, leafUnder: nil, bark: nil)
        
        let result = floraService.getAll()
        
        XCTAssertTrue(result.count == 1)
        
        if let flora = result.first
        {
            XCTAssertTrue(flora.leafUpper?.dimensions?.widthMin?.floatValue == 0.1)
            XCTAssertTrue(flora.leafUpper?.dimensions?.widthMax?.floatValue == 0.2)
            XCTAssertTrue(flora.leafUpper?.dimensions?.lengthMin?.floatValue == 10)
            XCTAssertTrue(flora.leafUpper?.dimensions?.lengthMax?.floatValue == 12)
        }
    }
    
    func testAddFloraWithOnlyLeafEdge()
    {
        let leafEdge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let leafUpper = leafService.addLeaf(nil, edge: leafEdge, color: nil, texture: nil)
        let _ = floraService.addFlora("Lemonwood", leafUpper: leafUpper, leafUnder: nil, bark: nil)
        
        if let first = floraService.getObjects(NSPredicate(format: "leafUpper.edgeType=%@", leafEdge!)).first
        {
            XCTAssertNotNil(first)
            XCTAssertNotNil(first.leafUpper)
            XCTAssertNotNil(first.leafUpper?.edgeType)
            XCTAssertNil(first.leafUpper?.dimensions)
            XCTAssertNil(first.leafUpper?.textureType)
        }
        else
        {
            XCTFail()
        }
    }
    
    func testGettingSingleObject() {
        
        let name:String = "Lancewood"
        let floraResult = floraService.addFlora(name)
        let flora = floraService.getObject(floraResult.objectID)
        
        XCTAssertNotNil(flora)
        XCTAssertEqual(flora?.commonName, name)
    }
    
    func testDeletingObjectThatExists() {
        
        floraService.addFlora("Lancewood")
        let floraToDelete = floraService.addFlora("Puke")
        
        var floraList = floraService.getAll()
        XCTAssertEqual(floraList.count, 2)
        
        floraService.deleteFlora(floraToDelete)
        floraList = floraService.getAll()
        XCTAssertEqual(floraList.count, 1)
    }
    
    func testGettingSingleObjectWhenMultipleExist() {
        
        let name:String = "Lancewood"
        floraService.addFlora(name)
        floraService.addFlora("Puka")
        floraService.addFlora("Lemonwood")

        let floraList = floraService.getObjects(NSPredicate(format: "commonName==%@", name))
    
        XCTAssertEqual(floraList.count, 1)
        XCTAssertEqual(floraList.first?.commonName, name)
    }

    func testDeleteAll() {
        
        floraService.addFlora("Lancewood")
        floraService.addFlora("Puka")
        floraService.addFlora("Lemonwood")
        
        var floraList = floraService.getAll()
        XCTAssertEqual(floraList.count, 3)
        
        let deleteCount = floraService.deleteAll()
        XCTAssertEqual(deleteCount, 3)
        
        floraList = floraService.getAll()
        XCTAssertEqual(floraList.count, 0)
    }
    
    func testGettingAll() {
        
        floraService.addFlora("Lancewood")
        floraService.addFlora("Puka")
        floraService.addFlora("Lemonwood")
        
        let floraList = floraService.getAll()
        XCTAssertNotNil(floraList)
        XCTAssertEqual(floraList.count, 3)
    }
    
    func testGroupByCommonName()
    {
        floraService.addFlora("AkeAke")
        floraService.addFlora("Puka")
        floraService.addFlora("Pittasporum")
        
        let flora = floraService.getAll()
        let grouped = floraService.groupByCommonName(flora)
        
        XCTAssertTrue(grouped.count == 2)
        XCTAssertTrue(grouped["A"]!.count == 1)
        XCTAssertTrue(grouped["P"]!.count == 2)
    }
}
