//
//  leafEdgeTypeTests.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class leafEdgeTypeTests: TestBase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetAll() {
        let edges = leafEdgeTypeService.getAll()
        let formations = leafFormationTypeService.getAll()
        
        XCTAssertTrue(edges.count > 0)
        XCTAssertTrue(formations.count > 0)
    }
    
    func testGetObjectByType()
    {
        let edge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Serrated)
        let formation = leafFormationTypeService.getObject(LeafFormationTypeEnum.Paired)
     
        XCTAssertTrue(edge?.name == "Serrated")
        XCTAssertTrue(formation?.name == "Paired")
    }

    func testGetObjectByName()
    {
        let edge = leafEdgeTypeService.getObject("Serrated")
        let formation = leafFormationTypeService.getObject("Paired")
        XCTAssertTrue(edge?.name == "Serrated")
        XCTAssertTrue(formation?.name == "Paired")
    }

    func testGetObjectByNameCaseDifferent()
    {
        let edge = leafEdgeTypeService.getObject("SERRATED")
        let formation = leafFormationTypeService.getObject("PAIRED")
        XCTAssertTrue(edge?.name == "Serrated")
        XCTAssertTrue(formation?.name == "Paired")
    }
    
    
}
