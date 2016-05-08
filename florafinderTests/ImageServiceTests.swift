//
//  ImageCacheTests.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 27/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class ImageServiceTests: TestBase {
    
    var masterDataProvider: DataStoreProviderProtocol?
    var cacheDataProvider: DataStoreProviderProtocol?
    var imageService: ImageService?
    
    override func setUp() {
        super.setUp()
        
        masterDataProvider = try? LocalDataStoreProvider(storeName: "TestDataStore")
        cacheDataProvider = try? CacheDataStoreProvider(storeName: "TestCache")
        imageService = ImageService(cacheDataStoreProvider: cacheDataProvider!, masterDataStoreProvider: masterDataProvider!)
    }
    
    override func tearDown() {
        super.tearDown()

        let _ = try? masterDataProvider?.deleteAll()
        let _ = try? cacheDataProvider?.deleteAll()
    }

    func testStoringJPGFiles() {
        let IMAGE_FILENAME = "kowhai_main.jpg"
        
        // get an image from the app bundle
        if let image = UIImage(named: IMAGE_FILENAME)
        {
            // add image to master store
            XCTAssertNotNil(masterDataProvider!.uploadImage(image, relativePath: "\(IMAGE_FILENAME)"), "Can't save data")
        }
    }
    
    func testGettingWhenCacheEmpty() {

        let IMAGE_FILENAME = "flower.png"
        
        // get an image from the app bundle
        if let image = UIImage(named: IMAGE_FILENAME)
        {
            // add image to master store
            XCTAssertNotNil(masterDataProvider!.uploadImage(image, relativePath: "\(IMAGE_FILENAME)"), "Can't save data")
            
            // Request image
            XCTAssertNotNil(imageService!.getImage(IMAGE_FILENAME), "Master should have provided the image")
            
            // ... and the image should now be in the cache
            XCTAssertNotNil(cacheDataProvider!.getImage(IMAGE_FILENAME), "Cache should have returned the image")
        }
        else
        {
            XCTFail()
        }
    }

    func testGettingWhenCacheHasResult() {
        
        let IMAGE_FILENAME = "flower.png"
        
        // get an image from the app bundle
        if let image = UIImage(named: IMAGE_FILENAME)
        {
            // add the file to the cache
            XCTAssertNotNil(cacheDataProvider?.uploadImage(image, relativePath: IMAGE_FILENAME))
            
            // request the image from the image service, should return the cached image
            XCTAssertNotNil(imageService!.getImage(IMAGE_FILENAME), "Cache should have returned the image")
        }
        else
        {
            XCTFail()
        }
    }
}
