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
    
    internal var rootFolder: NSURL
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
    
    func getImageRecords(nameOrPattern: String, recordFound: ((imageRecord: ImageRecord) -> Void))
    {
        if let paths = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(self.storeURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
        {
            for path in paths
            {
                if let data = NSFileManager.defaultManager().contentsAtPath(path.path!)
                {
                    if let image = UIImage(data: data)
                    {
                        let imageRecord = ImageRecord(image: image)
                        imageRecord.name = path.URLByDeletingPathExtension?.lastPathComponent
                        recordFound(imageRecord: imageRecord)
                    }
                }
            }
        }
    }

    func getFile(relativePath: String, completion: ((file: NSData?) -> Void))
    {
        completion(file:  NSFileManager.defaultManager().contentsAtPath(fullPath(relativePath).path!))
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
        if let imageData = UIImagePNGRepresentation(image)
        {
            return uploadFile(imageData, relativePath: relativePath)
        }
        return nil
    }
    
    func fileExists(path: String, completion: (Bool) -> Void)
    {
        let result = NSFileManager.defaultManager().fileExistsAtPath(fullPath(path).path!)
        completion(result)
    }
    
    func deleteAll(completion: (Bool) -> Void)
    {
        // Assume all will be good
        var result = true
        
        let fileManager = NSFileManager.defaultManager()
        if let paths = try? fileManager.contentsOfDirectoryAtPath(self.storeURL!.path!)
        {
            for path in paths
            {
                do
                {
                    try fileManager.removeItemAtPath(self.storeURL.URLByAppendingPathComponent(path).path!)
                }
                catch
                {
                    result = false
                    break
                }
            }
        }
        completion(result)
    }
}