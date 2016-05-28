//
//  LocalDataStoreProvider.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 27/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum DataStoreProviderError: ErrorType {
    case CantCreateStore
    case ErrorWritingFile
    case UnsupportedFileExtension
}

class LocalDataStoreProvider: DataStoreProviderProtocol
{
    var storeURL: NSURL!
    
    /**
     Initialise a local store provider
     
     - Parameter storeName: the unique name to refer to the store by
     */
    init(storeName: String) throws
    {
        self.storeURL = try initializeStore(storeName)
    }
    
    var rootFolder: NSURL
    {
        // Return the app's Document directory
        return NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!)
    }
    
    internal func initializeStore(name: String) throws -> NSURL
    {
        var url: NSURL?
        
        url = rootFolder.URLByAppendingPathComponent(name)
            
        // create store directory if it's not there
        if let storePath = url?.path
        {
            if !NSFileManager.defaultManager().fileExistsAtPath(storePath)
            {
                do
                {
                    // Attempt to create store directory
                    try NSFileManager.defaultManager().createDirectoryAtPath(storePath, withIntermediateDirectories: false, attributes: nil)
                }
                catch
                {
                    throw DataStoreProviderError.CantCreateStore
                }
            }
        }
        else
        {
            // Can't find the document directory or something else wierd
            throw DataStoreProviderError.CantCreateStore
        }
        
        return url!
    }
    
    func fullPath(relativePath: String) -> NSURL
    {
        return self.storeURL.URLByAppendingPathComponent(relativePath)
    }
    
    func getImage(relativePath: String) -> UIImage?
    {
        return UIImage(contentsOfFile: fullPath(relativePath).path!)
    }
    
    func getImageRecordsFromFolder(folderPath: String) -> [ImageRecord]
    {
        return [ImageRecord]()
    }
    
    func getImageRecords(nameOrPattern: String) -> [ImageRecord]
    {
        return [ImageRecord]()
    }
    
    func getFile(relativePath: String, completion: ((file: NSData?) -> Void))
    {
        completion(file:  NSFileManager.defaultManager().contentsAtPath(fullPath(relativePath).path!))
    }
    
    func getFile(relativePath: String) -> NSData?
    {
        return NSFileManager.defaultManager().contentsAtPath(fullPath(relativePath).path!)
    }

    func uploadFile(file: NSData, relativePath: String) -> NSURL?
    {
        do
        {
            try file.writeToURL(fullPath(relativePath), options: NSDataWritingOptions.DataWritingAtomic)
            return fullPath(relativePath)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            //throw DataStoreProviderError.ErrorWritingFile
            return nil
        }
    }
    
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    {
        var imageData: NSData!
        
        if (relativePath.hasSuffix("jpg"))
        {
            imageData = UIImageJPEGRepresentation(image, 1)
        }
        else if (relativePath.hasSuffix("png"))
        {
            imageData = UIImagePNGRepresentation(image)
        }
        else
        {
            //throw DataStoreProviderError.UnsupportedFileExtension
            return nil
        }
        
        return uploadFile(imageData, relativePath: relativePath)
    }
    
    func fileExists(relativePath: String) -> Bool
    {
        return NSFileManager.defaultManager().fileExistsAtPath(fullPath(relativePath).path!)
    }
    
    func deleteAll() throws -> Bool
    {
        let fileManager = NSFileManager.defaultManager()
        let paths = try fileManager.contentsOfDirectoryAtPath(self.storeURL!.path!)
        for path in paths
        {
            try fileManager.removeItemAtPath(self.storeURL.URLByAppendingPathComponent(path).path!)
        }
        return true
    }
}