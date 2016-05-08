//
//  importTests.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 1/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import florafinder

class importTests: TestBase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFullImportOfSingleRow() {
        
        let semaphoreWaitKey = "testFullImportOfSingleRow"
        
        let externalURL = "https://en.wikipedia.org/wiki/Fuscospora_solandri"
        
        let l1 = "CommonName,LeafMinWidth,LeafMaxWidth,LeafMinLength,LeafMaxLength,FlowerColor,FruitColor,LeafEdge,LeafFormation,LeafTexture,ExternalURL"
        let l2 = "Pohutakawa,10.1,0.2,3,4,Red,Green,Smooth,Paired,Hairy,\(externalURL)"
        let contents = [l1, l2].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)
            
            importer.importFile(
                {
                    result in
                    
                    let message = result.messages == nil ? "OK" : (result.messages?.summary)!
                    print(message)
                    XCTAssertTrue(result.status == TOKImportStatus.Success, message)
                    XCTAssertTrue(result.rawData.count == 2)
                    XCTAssertTrue(result.savedData.count == 1)
                    
                    // Check save succeeded
                    let floraInDatastore = self.floraService.getObject("Pohutakawa")
                    XCTAssertNotNil(floraInDatastore)
                    
                    // Check properties correct
                    let importedFlora = result.savedData.first as! Flora
                    
                    XCTAssertTrue(floraInDatastore?.commonName == importedFlora.commonName)
                    XCTAssertTrue(floraInDatastore?.leafUpper?.dimensions?.widthMin?.floatValue == 10.1)
                    XCTAssertTrue(floraInDatastore?.leafUpper?.dimensions?.widthMax?.floatValue == 0.2)
                    XCTAssertTrue(floraInDatastore?.leafUpper?.dimensions?.lengthMin?.floatValue == 3)
                    XCTAssertTrue(floraInDatastore?.leafUpper?.dimensions?.lengthMax?.floatValue == 4)
                    
                    XCTAssertTrue(floraInDatastore?.flowerColor == self.flowerColorTypeService.getObject(FlowerColorTypeEnum.Red))
                    XCTAssertTrue(floraInDatastore?.fruitColor == self.fruitColorTypeService.getObject(FruitColorTypeEnum.Green))
                    XCTAssertTrue(floraInDatastore?.leafUpper?.edgeType == self.leafEdgeTypeService.getObject(LeafEdgeTypeEnum.Smooth))
                    XCTAssertTrue(floraInDatastore?.leafUpper?.formationType == self.leafFormationTypeService.getObject(LeafFormationTypeEnum.Paired))
                    XCTAssertTrue(floraInDatastore?.leafUpper?.textureType == self.leafTextureTypeService.getObject(LeafTextureTypeEnum.Hairy))
                    XCTAssertTrue(floraInDatastore?.externalURL == externalURL)
                    
                    // release the semaphore
                    Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)
            
            // Tidy up
            self.deleteFile(fileURL)
        }
    }
    
    func testExistingFloraUpdatesNotAddsRecord() {
    
        let semaphoreWaitKey = "testExistingFloraUpdatesNotAddsRecord"
        let commonName = "Pohutakawa"
        
        // Add Pohutakaw flora
        self.serviceFactory.floraService.addFlora(commonName)
        
        let l1 = "CommonName,LeafMinWidth,LeafMaxWidth,LeafMinLength,LeafMaxLength,FlowerColor,FruitColor"
        let l2 = commonName + ",1,2,3,4,Red,Green"
        let contents = [l1, l2].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)

            importer.importFile(
            {
                result in
                
                let message = result.messages == nil ? "OK" : (result.messages?.summary)!
                print(message)
                XCTAssertTrue(result.status == TOKImportStatus.Success, message)
            
                // Make sure there's still only one flora
                let flora = self.floraService.getAll()
                XCTAssertTrue(flora.count == 1)
                
                // release the semaphore
                Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)

            // Tidy up
            self.deleteFile(fileURL)
        }
    }

    func testMissingLookupTypesOK() {
        
        let semaphoreWaitKey = "testMissingFieldOK"
        
        let h = "CommonName,LeafMinWidth,LeafMaxWidth,LeafMinLength,LeafMaxLength,LeafColor,FlowerColor,FruitColor, LeafColor,LeafEdge,LeafTexture"
        let l1 = "Rimu,1,2,3,4,,,,,,," // ok to have missing color lookups

        let contents = [h, l1].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)
            
            importer.validate(
                {
                    result in
                    
                    print(result.messages.summary)
                    // Should be no warnings about missing fields.
                XCTAssertTrue(result.messages.messagesOfSeverity(TOKImportMessageSeverity.Warning).count == 0)
                    XCTAssertTrue(result.validLinesCount == 1)
                    
                    // release the semaphore
                    Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)
            
            // Tidy up
            self.deleteFile(fileURL)
        }
    }

    func testRandom() {
        
        let semaphoreWaitKey = "testRandom"
        
        let h = "CommonName,LatinName,Notes,LeafMinLength,LeafMaxLength,LeafMinWidth,LeafMaxWidth,LeafColor,LeafEdge,LeafFormation,LeafTexture,LeafGloss,LeafNotes,FlowerColor,FruitColor,Trunk,ExternalURL,Image"
        let l1 = "Pohutakawa,,,5,8,2,3,,Smooth,Paired,Smooth,Semi,\"I have a comma, in me\",Red,,\"Gnarled with spreading roots, found throughout New Zealand\",https://en.wikipedia.org/wiki/Metrosideros_excelsa,"
        
        let contents = [h, l1].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)
            
            importer.importFile(
                {
                    result in
                    
                    print(result.messages.summary)
                    
                    XCTAssertTrue(result.validLinesCount == 1)
                    
                    if (result.savedData.count == 1)
                    {
                        let flora = result.savedData[0] as! Flora
                        
                        XCTAssertTrue(flora.leafUpper?.notes == "I have a comma, in me")
                    }
                    else
                    {
                        XCTFail()
                    }
                    
                    // release the semaphore
                    Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)
            
            // Tidy up
            self.deleteFile(fileURL)
        }
    }
    
    func testNumericValuesFailIfNonNumeric() {
        
        let semaphoreWaitKey = "testNumericValuesFailIfNonNumeric"
        
        let h = "CommonName,LeafMinWidth,LeafMaxWidth,LeafMinLength,LeafMaxLength"
        let l1 = "Rimu,1,1,1,1" // all good
        let l2 = "Lemonwood,,,," // all good
        let l3 = "Matai,x,x,x,x" // all bad
        let l4 = "Miro,1,1,x,x" // some bad
        
        let contents = [h, l1, l2, l3, l4].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)
            
            importer.validate(
                {
                    result in
                    
                    print(result.messages.summary)
                    
                    XCTAssertTrue(result.validLinesCount == 2)
                    
                    XCTAssertTrue(result.messages.messagesOfSeverity(TOKImportMessageSeverity.FatalError).count == 6)
                    
                    // release the semaphore
                    Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)
            
            // Tidy up
            self.deleteFile(fileURL)
        }
    }

    func testLookupValuesAreCaseInsensitive() {
        
        let semaphoreWaitKey = "testLookupValuesAreCaseInsensitive"
        
        let h = "CommonName,FruitColor,FlowerColor,LeafColor,LeafTexture,LeafEdge"
        let l1 = "Rimu,RED,RED,GREEN,SMOOTH,SERRATED"

        let contents = [h, l1].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)
            
            importer.validate(
                {
                    result in
                    
                    print(result.messages.summary)

                    XCTAssertTrue(result.validLinesCount == 1)
                    
                    // release the semaphore
                    Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)
            
            // Tidy up
            self.deleteFile(fileURL)
        }
    }

    func testInvalidLookupStopsRowImporting() {
        
        let semaphoreWaitKey = "testInvalidLookupStopsRowImporting"
        
        let h = "CommonName,LeafMinWidth,LeafMaxWidth,LeafMinLength,LeafMaxLength,FlowerColor,FruitColor"
        let l1 = "Rimu,1,2,3,4,Red,xxx" // won't import, xxx not valid Fruit color
        let l2 = "Pohutakawa,1,2,3,4,Red,Orange" // OK on both Flower and Fruit colors
        let contents = [h, l1, l2].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)
            
            importer.validate(
                {
                    result in

                    print(result.messages.summary)
                    
                    // Expect one warning for bad fruit color
                    let warningMessages = result.messages.messagesOfSeverity(TOKImportMessageSeverity.FatalError)
                    XCTAssertTrue(warningMessages.count == 1)
                    
                    XCTAssertTrue(result.validLinesCount == 1)
                    
                    // release the semaphore
                    Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)
            
            // Tidy up
            self.deleteFile(fileURL)
        }
    }
    
    func testMissingMandatoryColumnsStopImport() {
        
        let semaphoreWaitKey = "testMissingMandatoryColumns"
        
        let h = "CommoName,LeaMinWidth,LeafMaxWidth,LeafMinLength,LeafMaxLength,FlowerColor,FruitColor"
        let l1 = "Pohutakawa,1,2,3,4,Red,Green"
        let contents = [h, l1].joinWithSeparator("\n")
        
        if let fileURL = createFile("test.csv", contents: contents)
        {
            let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: fileURL)
            
            importer.importFile(
                {
                    result in
                    
                    // Expect importer to complain about missing CommonName only
                    let criticalMessages = result.messages.messagesOfSeverity(TOKImportMessageSeverity.CriticalFileError)
                    XCTAssertTrue(criticalMessages.count == 1)
                    XCTAssertTrue(result.messages.summary.containsString("CommonName"))
                    
                    // release the semaphore
                    Semaphore.sharedInstance.lift(semaphoreWaitKey)
            })
            
            // Wait for the completeBlock to be called and the semaphore to be lifted
            Semaphore.sharedInstance.waitForKey(semaphoreWaitKey)
            
            // Tidy up
            self.deleteFile(fileURL)
        }
    }
    
    func testURLColumn()
    {
        let importer = FloraImporter()
        
        let invalidURL = "fred"
        let validURL = "https://en.wikipedia.org/wiki/Fuscospora_solandri"
        
        XCTAssertTrue(importer.externalURLColumn.isValidField(validURL))
        XCTAssertFalse(importer.externalURLColumn.isValidField(invalidURL))
        
    }
    func createFile(filename: String, contents: String) -> NSURL?
    {
        let file = NSFileManager.defaultManager()
        let paths = file.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        if let fileURL = paths.first?.URLByAppendingPathComponent(filename, isDirectory: false)
        {
            do
            {
                try contents.writeToURL(fileURL, atomically: true, encoding: NSUTF8StringEncoding)
                return fileURL
            }
            catch
            {
                XCTFail()
            }
        }
        return nil
    }

    func deleteFile(fileURL: NSURL)
    {
        let file = NSFileManager.defaultManager()
        do
        {
            try file.removeItemAtURL(fileURL)
        }
        catch
        {
            XCTFail()
        }
    }

}
