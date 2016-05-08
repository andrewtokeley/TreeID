//
//  SearchTexts.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 29/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class SearchTests: TestBase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        //self.serviceFactory.coreDataController.rollback()
    }

//    func testCombiningSearchResults()
//    {
//        let flora = floraService.addFlora("Lemonwood", leafUpper: nil, leafUnder: nil, bark: nil)
//        
//        
//    }
    
    func testSearchByDimension()
    {
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 0.1, length: 10), maximumSize: Measurement(width: 0.2, length: 12))
        
        let leaf = leafService.addLeaf(dimension, edge: nil, color: nil, texture: nil)
        let _ = floraService.addFlora("tree", leafUpper: leaf, leafUnder: nil, bark: nil)

        // Search for this leaf from a leaf with width = 0.2 length = 11
        let searchTerm = SearchTermByDimension(size: Measurement(width: 0.2,length: 11), tolerance: 0)
        searchTerm.leafDimensionService = leafDimensionService
        let results = floraService.performSearch([searchTerm])
        
        XCTAssertTrue(results?.count == 1)
    }
    
    func testSearchByDimensionWithTolerance()
    {
        
        let dimension = leafDimensionService.addLeafDimension(Measurement(width: 1, length: 2), maximumSize: Measurement(width: 1, length: 2))
        
        let leaf = leafService.addLeaf(dimension, edge: nil, color: nil, texture: nil)
        let _ = floraService.addFlora("tree", leafUpper: leaf, leafUnder: nil, bark: nil)
        
        // Search for this leaf from a leaf with width = 0.2 length = 11
        let searchTerm = SearchTermByDimension(size: Measurement(width: 0.998596, length: 1.99719), tolerance: 0.2)
        searchTerm.leafDimensionService = leafDimensionService
        let results = floraService.performSearch([searchTerm])
        
        XCTAssertTrue(results?.count == 1)
    }
    
    func testSearchByLookupTypes()
    {
        // Create Leaf
        let edge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let formation = leafFormationTypeService.getObject(LeafFormationTypeEnum.Alternate)
        let fruitColor = fruitColorTypeService.getObject(FruitColorTypeEnum.Red)
        let flowerColor = flowerColorTypeService.getObject(FlowerColorTypeEnum.Yellow)
        let leafTexture = leafTextureTypeService.getObject(LeafTextureTypeEnum.Smooth)
        
        let leaf = leafService.addLeaf(nil, edge: edge, color: nil, texture: leafTexture)
        leaf.formationType = formation
        
        // Create Flora with this Leaf
        let flora = floraService.addFlora("tree", leafUpper: leaf, leafUnder: nil, bark: nil)
        flora.fruitColor = fruitColor
        flora.flowerColor = flowerColor
        
        // Search for flora with smooth, alternative leaves
        //let searchItem_edge = SearchTermByLookupType(lookupType: LookupTypeEnum.LeafEdgeType, value: edge!)
        let searchItem_edge = SearchTermByLeafEdge(leafEdgeType: edge!)
        let searchItem_formation = SearchTermByLeafFormation(leafFormationType: formation!)
        let searchItem_fruitColor = SearchTermByFruitColor(fruitColorType: fruitColor!)
        let searchItem_flowerColor = SearchTermByFlowerColor(flowerColorType: flowerColor!)
        let searchItem_leafTexture = SearchTermByLeafTexture(leafTextureType: leafTexture!)
        
        
        
        let results = floraService.performSearch([searchItem_edge, searchItem_formation, searchItem_fruitColor, searchItem_flowerColor, searchItem_leafTexture])
        
        XCTAssertTrue(results?.count == 1)
        XCTAssertTrue(results?.first?.relevance == 5) // for matching on each lookup
        XCTAssertTrue(results?.first?.hitCount == 5) // for matching on each lookup
    }
    
    func testStrictSearchReturnsOnlyFloraMatchingAllSearchTerms()
    {
        // Create Leaf
        let edge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let formation = leafFormationTypeService.getObject(LeafFormationTypeEnum.Alternate)
        let leaf = leafService.addLeaf(nil, edge: edge, color: nil, texture: nil)
        leaf.formationType = formation
        
        // Create Leaf
        let edge2 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Rippled)
        let formation2 = leafFormationTypeService.getObject(LeafFormationTypeEnum.Alternate)
        let leaf2 = leafService.addLeaf(nil, edge: edge2, color: nil, texture: nil)
        leaf2.formationType = formation2
        
        // Create Leaf
        let edge3 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let formation3 = leafFormationTypeService.getObject(LeafFormationTypeEnum.Paired)
        let leaf3 = leafService.addLeaf(nil, edge: edge3, color: nil, texture: nil)
        leaf3.formationType = formation3
        
        // Create Flora with this Leaf
        let _ = floraService.addFlora("tree", leafUpper: leaf, leafUnder: nil, bark: nil)
        let _ = floraService.addFlora("tree2", leafUpper: leaf2, leafUnder: nil, bark: nil)
        let _ = floraService.addFlora("tree3", leafUpper: leaf3, leafUnder: nil, bark: nil)

        // Search for flora with smooth, alternative leaves - only one record matches all these
        let searchItem_edge = SearchTermByLeafEdge(leafEdgeType: edge!)
        let searchItem_formation = SearchTermByLeafFormation(leafFormationType: formation!)
        
        //strict search
        let results = floraService.performSearch([searchItem_edge, searchItem_formation], strict: true)
        
        XCTAssertTrue(results?.count == 1) // only one flora matches everything
        XCTAssertTrue(results?.first?.flora.commonName == "tree")
        
        
    }
    
    func testResultsReturnedWithMostRelevantFirst()
    {
        // Create Leaf
        let edge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let formation = leafFormationTypeService.getObject(LeafFormationTypeEnum.Alternate)
        let leaf = leafService.addLeaf(nil, edge: edge, color: nil, texture: nil)
        leaf.formationType = formation
        
        // Create Leaf
        let edge2 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Rippled)
        let formation2 = leafFormationTypeService.getObject(LeafFormationTypeEnum.Alternate)
        let leaf2 = leafService.addLeaf(nil, edge: edge2, color: nil, texture: nil)
        leaf2.formationType = formation2

        // Create Leaf
        let edge3 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Serrated)
        let formation3 = leafFormationTypeService.getObject(LeafFormationTypeEnum.Paired)
        let leaf3 = leafService.addLeaf(nil, edge: edge3, color: nil, texture: nil)
        leaf3.formationType = formation3

        // Create Flora with this Leaf
        let _ = floraService.addFlora("findmetoo", leafUpper: leaf, leafUnder: nil, bark: nil)
        let _ = floraService.addFlora("tree2", leafUpper: leaf2, leafUnder: nil, bark: nil)
        let _ = floraService.addFlora("tree3", leafUpper: leaf3, leafUnder: nil, bark: nil)
        
        // Search for flora with smooth, alternative leaves
        let searchItem_edge = SearchTermByLeafEdge(leafEdgeType: edge!)
        let searchItem_formation = SearchTermByLeafFormation(leafFormationType: formation!)
        let searchItem_keyword = SearchTermByKeyword(keyword: "findmetoo")
        
        let results = floraService.performSearch([searchItem_edge, searchItem_formation, searchItem_keyword])
        
        XCTAssertTrue(results?.count == 3)
        XCTAssertTrue(results?.first?.relevance == 3) // for matching on both lookups and keyword
        XCTAssertTrue(results?[1].relevance == 1) // for matching on both lookups
        XCTAssertTrue(results?.last?.relevance == 0) // for matching nothinf
    }
    
    func testWhenFloraHasTwoHitsRelevanceHigher()
    {
        let leafEdge1 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let leafTexture1 = leafTextureTypeService.getObject(LeafTextureTypeEnum.Hairy)
        let leafUpper1 = leafService.addLeaf(nil, edge: leafEdge1, color: nil, texture: leafTexture1)
        let _ = floraService.addFlora("Lemonwood", leafUpper: leafUpper1, leafUnder: nil, bark: nil)
        
        let leafEdge2 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Rippled)
        let leafUpper2 = leafService.addLeaf(nil, edge: leafEdge2, color: nil, texture: nil)
        let _ = floraService.addFlora("Pittasporum", leafUpper: leafUpper2, leafUnder: nil, bark: nil)
        
        // Search for flora with smooth edge, hairy flora
        let searchItem1 = SearchTermByLeafEdge(leafEdgeType: leafEdge1!)
        let searchItem2 = SearchTermByLeafTexture(leafTextureType: leafTexture1!)

        let results = floraService.performSearch([searchItem1, searchItem2])
        
        XCTAssertTrue(results?.count == 1)
        XCTAssertTrue(results?.first!.relevance == 2) // because 2 matching terms
    }
    
    func testWhenTwoMatchesDifferentRelevance()
    {
        let leafEdge1 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let leafTexture1 = leafTextureTypeService.getObject(LeafTextureTypeEnum.Hairy)
        let leafUpper1 = leafService.addLeaf(nil, edge: leafEdge1, color: nil, texture: leafTexture1)
        let lemonwood = floraService.addFlora("Lemonwood", leafUpper: leafUpper1, leafUnder: nil, bark: nil)
        
        let leafEdge2 = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Rippled)
        let leafUpper2 = leafService.addLeaf(nil, edge: leafEdge2, color: nil, texture: nil)
        let _ = floraService.addFlora("Pittasporum", leafUpper: leafUpper2, leafUnder: nil, bark: nil)
        
        // Search for flora with smooth edge, hairy flora
        let searchItem1 = SearchTermByLeafEdge(leafEdgeType: leafEdge1!)
        let searchItem2 = SearchTermByLeafEdge(leafEdgeType: leafEdge2!)
        let searchItem3 = SearchTermByLeafTexture(leafTextureType: leafTexture1!)

        let results = floraService.performSearch([searchItem1, searchItem2, searchItem3])
        
        // Both flora should match
        XCTAssertTrue(results?.count == 2)
        
        // Make sure Lemonwood matched twice
        if let lemonwoodMatch = results?.filter({ result in result.flora == lemonwood })
        {
            XCTAssertTrue(lemonwoodMatch.count == 1)
            XCTAssertTrue(lemonwoodMatch.first!.relevance == 2)
        }
        else
        {
            XCTFail("Lemonwood didn't match")
        }
    }
    
    func testStringMatch()
    {
        let searchString = "test this is a test of test being found"
        let count = searchString.numberOfMatches("test")
        
        XCTAssertTrue(count == 3)
    }
    
    func testKeywordMatchOnLookupName()
    {
        let leafEdge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let leafUpper = leafService.addLeaf(nil, edge: leafEdge, color: nil, texture: nil)
        let _ = floraService.addFlora("Lemonwood", leafUpper: leafUpper, leafUnder: nil, bark: nil)
        
        let keywordSearch = SearchTermByKeyword(keyword: "Smooth")
        
        let results = floraService.performSearch([keywordSearch])
        
        XCTAssertTrue(results?.count == 1)
        XCTAssertTrue(results?.first?.relevance == 1) // only one occurrance of "Smooth"
    }
    
    func testKeywordMatchesTwoLookups()
    {
        let leafEdge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let leafTexture = leafTextureTypeService.getObject(LeafTextureTypeEnum.Smooth)
        let leafUpper = leafService.addLeaf(nil, edge: leafEdge, color: nil, texture: leafTexture)
        let _ = floraService.addFlora("Lemonwood", leafUpper: leafUpper, leafUnder: nil, bark: nil)
        
        let keywordSearch = SearchTermByKeyword(keyword: "Smooth")
        
        let results = floraService.performSearch([keywordSearch])
        
        XCTAssertTrue(results?.count == 1)
        XCTAssertTrue(results?.first?.relevance == 2) // two matches on Smooth
    }

    func testMatchOnKeywordAndLookup()
    {
        let leafEdge = leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth)
        let leafTexture = leafTextureTypeService.getObject(LeafTextureTypeEnum.Rough)
        let leafUpper = leafService.addLeaf(nil, edge: leafEdge, color: nil, texture: leafTexture)
        let _ = floraService.addFlora("Lemonwood", leafUpper: leafUpper, leafUnder: nil, bark: nil)
        
        // Search for something with Lemon and smooth leaves
        let keywordSearch = SearchTermByKeyword(keyword: "Lemon")
        let smoothLeafSearch = SearchTermByLeafTexture(leafTextureType: leafTexture!)
        
        let results = floraService.performSearch([keywordSearch, smoothLeafSearch])
        
        XCTAssertTrue(results?.count == 1)
        XCTAssertTrue(results?.first?.relevance == 2) // two matches on Keyword and Smooth lookup
    }

}
