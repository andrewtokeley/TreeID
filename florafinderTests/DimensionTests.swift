//
//  DimensionTests.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 21/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class DimensionTests: TestBase {
    
    override func setUp() {
        super.setUp()
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRatioNarrow()
    {
        // very long, narrow leaf
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 1, length: 12), maximumSize: Measurement(width: 3, length: 40))
        
        XCTAssertTrue(dimension.shape == LeafShapeEnum.Narrow)
    }
    
    func testRatioIfNoDimensions()
    {
        // very broad leaf
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 7, length: 6), maximumSize: Measurement(width: 9, length: 10))
        dimension.lengthMax = nil
        dimension.lengthMin = nil
        dimension.widthMax = nil
        dimension.widthMin = nil
        
        XCTAssertTrue(dimension.ratio == 0)
    }

    
    func testRatioBroad()
    {
        // very broad leaf
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 7, length: 6), maximumSize: Measurement(width: 9, length: 10))
      
        XCTAssertTrue(dimension.shape == LeafShapeEnum.Broad)
    }
    
    func testRatioRegular()
    {
        // normal leaf ratio (ratio 2)
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 1, length: 2), maximumSize: Measurement(width: 2, length: 4))
        
        XCTAssertTrue(dimension.shape == LeafShapeEnum.Regular)
    }
    
    func testVarianceBetweenSizeAndDimension() {
    
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 1, length: 2), maximumSize: Measurement(width: 4, length: 6))

        // perfect match would be (2.5, 4)
        let perfecHit = leafDimensionService.deviationOfSizeFromDimension(dimension, size: Measurement(width: 2.5, length: 4))
        XCTAssertTrue(perfecHit == Measurement(width: 0,length: 0), "\(perfecHit) not zero")
        
        // anywhere inside the range will be less than 2 deviations
        let insideDeviation = leafDimensionService.deviationOfSizeFromDimension(dimension, size: Measurement(width: 3.2, length: 5.2))
        XCTAssertTrue(insideDeviation.width <= 2 && insideDeviation.length <= 2, "\(perfecHit) not within 2 deviations")
        
        
    }

}
