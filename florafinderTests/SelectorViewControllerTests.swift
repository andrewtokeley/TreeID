//
//  SelectorViewControllerTests.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 22/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class SelectorViewControllerTests: XCTestCase, SelectorDelegate {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func selector(selector: SelectorViewController, itemSelected:SelectorItem)
    {
        
    }
    
    func testDatasourceForBindingIncludesNilSelection() {
        let controller = SelectorViewController(dataSource: ["One", "Two", "Three"], allowNilSelection: true, selectedIndex: 1, title: "Test", delegate: self, tag: nil, selectorItemBlock: { item in return SelectorItem(title: item as! String, subTitle: nil, object: item)})
        
        XCTAssert(controller.datasourceForBinding.count == 4)
        XCTAssert(controller.datasourceForBinding[0].object == nil)
    }

    func testInitialiseSecondItemAsSelectedItem() {
        let controller = SelectorViewController(dataSource: ["One", "Two", "Three"], allowNilSelection: false, selectedIndex: 1, title: "Test", delegate: self, tag: nil, selectorItemBlock: { item in return SelectorItem(title: item as! String, subTitle: nil, object: item)})
        
        // Without even selecting should be pointing to second item
        XCTAssert(controller.selectedItem?.title == "Two")
    }
    
    func testSelectSecondItemGivenNilSelectionAllowed() {
        let controller = SelectorViewController(dataSource: ["One", "Two", "Three"], allowNilSelection: true, selectedIndex: 1, title: "Test", delegate: self, tag: nil, selectorItemBlock: { item in return SelectorItem(title: item as! String, subTitle: nil, object: item)})
        
        // select the second item in the rendered list - this should include
        controller.selectItemFromList(2)
        
        XCTAssert(controller.selectedItem?.title == "Two")
    }
    
    func testSelectFirstItemGivenNilSelectionNotAllowed() {
        let controller = SelectorViewController(dataSource: ["One", "Two", "Three"], allowNilSelection: false, selectedIndex: 1, title: "Test", delegate: self, tag: nil, selectorItemBlock: { item in return SelectorItem(title: item as! String, subTitle: nil, object: item)})
        
        // select the second item in the rendered list - this should include
        controller.selectItemFromList(1)
        
        XCTAssert(controller.selectedItem?.title == "Two")
    }
    
    func testInitialiseWithNoItemGivesNilSelectedItem() {
        let controller = SelectorViewController(dataSource: ["One", "Two", "Three"], allowNilSelection: false, selectedIndex: nil, title: "Test", delegate: self, tag: nil, selectorItemBlock: { item in return SelectorItem(title: item as! String, subTitle: nil, object: item)})
        
        XCTAssertNil(controller.selectedItem)
    }

}
