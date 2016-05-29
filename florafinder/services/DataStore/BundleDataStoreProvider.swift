//
//  BundleDataStoreProvider.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 20/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class BundleDataStoreProvider: DataStoreProviderProtocol
{
    init()
    {

    }

    func getFile(name: String, completion: ((file: NSData?) -> Void))
    {
        completion(file: getFile(name))
    }
    
    func getFile(name: String) -> NSData? {
        
        if let url = NSBundle.mainBundle().URLForResource(name, withExtension: nil)
        {
            return NSData(contentsOfURL: url)
        }
        return nil
    }
    
    func getImage(name: String) -> UIImage?
    {
        return UIImage(named: name)
    }
    
    func fileExists(name: String) -> Bool
    {
        if let _ = NSBundle.mainBundle().URLForResource(name, withExtension: nil)
        {
            return true
        }
        return false
    }
    
    func getImageRecordsFromFolder(folderPath: String) -> [ImageRecord]
    {
        fatalError("not implemented")
    }
    
    func getImageRecords(nameOrPattern: String) -> [ImageRecord]
    {
        return [ImageRecord]()
    }
    
    func getImageRecords(nameOrPattern: String, inFolder: String?, completion: ((imageRecords: [ImageRecord]) -> Void))
    {
        
    }

    func uploadFile(file: NSData, relativePath: String) -> NSURL?
    {
        fatalError("not implemented")
    }
    
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    {
        fatalError("not implemented")
    }

    func deleteAll() throws -> Bool
    {
        fatalError("not implemented")
    }
}