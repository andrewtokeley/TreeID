//
//  IPhoneGridTests.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class IPhoneGridTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRatioOfDerivedGridMatchesPhoneRatio() {
        let grid = IPhoneGrid(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 300)), rows: 2, columns: 3)
        
        let derivedRatio = grid.phoneRectSize.width/grid.phoneRectSize.height
        let phoneRatio = Units.sizeOfPhoneInCentimetres.width/Units.sizeOfPhoneInCentimetres.height
        
        XCTAssertTrue(derivedRatio == phoneRatio)
    }

//    func testHeightConstrained()
//    {
//        let grid = IPhoneGrid(frame: CGRect(origin: CGPointZero, size: CGSize(width: Units.sizeOfPhoneInCentimetres.width + 100, height: Units.sizeOfPhoneInCentimetres.height)), rows: 3, columns: 2)
//    
//        // phone grids should be constrained to the height of the frame
//        let totalPhoneGridHeights = grid.phoneRectSize.height * 3
//
//        XCTAssertTrue(totalPhoneGridHeights == Units.sizeOfPhoneInCentimetres.height)
//    }
//
//    func testWidthConstrained()
//    {
//        let grid = IPhoneGrid(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 300)), rows: 1, columns: 4)
//        
//        // phone grids should be constrained to the height of the frame
//        let totalPhoneGridWidths = grid.phoneRectSize.width * 4
//        print(totalPhoneGridWidths)
//        
//        XCTAssertTrue(totalPhoneGridWidths == 100)
//    }
    
func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
