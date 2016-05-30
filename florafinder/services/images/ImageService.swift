//
//  ImageCacheService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 27/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ImageService
{
    var cacheDataStore: DataStoreProviderProtocol!
    var masterDataStoreProvider: DataStoreProviderProtocol!
    
    /**
     Initialise the ImageCacheService with a location and data provider
     
     - Parameter cachePath: Fully qualified path to the local cache directory
     - Parameter masterDataStoreProvider: The provider implementation which knows how to retrieve image data from a particular store, e.g. S3DataStoreProvider if storing images on S3
     */
    init(cacheDataStoreProvider: DataStoreProviderProtocol, masterDataStoreProvider: DataStoreProviderProtocol)
    {
        self.cacheDataStore = cacheDataStoreProvider
        self.masterDataStoreProvider = masterDataStoreProvider
    }
    
    lazy var placeholderImage: UIImage =
    {
        if let image = UIImage(named: "placeholder.png")
        {
            return image
        }
        return UIImage()
    }()
    
//    func getImageRecordsInFolder(folderPath: String) -> [ImageRecord]
//    {
//         return [ImageRecord]()
//    }
    
//    func getImageRecords(nameOrPattern: String) -> [ImageRecord]
//    {
//        fatalError("deprecated")
//    }
    
    func getImageRecords(nameOrPattern: String, recordFound: (ImageRecord) -> Void)
    {
        self.masterDataStoreProvider.getImageRecords(nameOrPattern, recordFound: {
            (imageRecord) in
            
            recordFound(imageRecord)
        })    
    }
    
//    func getImageRecord(relativePath: String) -> ImageRecord?
//    {
//        if let image = getImage(relativePath)
//        {
//            // meta files have the same path as
//            let metaPath = relativePath.stringByAppendingString(".meta")
//            let meta = getFile(metaPath)
//            
//            return ImageRecord(image: image, metaData: meta)
//        }
//        return nil
//    }
    
    /**
     Gets the specified image, either in the local cache, or in the datastore provider if not there.
     */
    
    func getFile(relativePath: String, completion: (NSData) -> Void)
    {
        cacheDataStore.fileExists(relativePath, completion: {
            (result) in
            if (result)
            {
                self.cacheDataStore.getFile(relativePath, completion: { (file) in
                    if (file != nil)
                    {
                        completion(file!)
                    }
                })
            }
            else
            {
                self.masterDataStoreProvider.getFile(relativePath, completion: { (file) in
                    
                    if (file != nil)
                    {
                        // add file to cache
                        self.cacheDataStore.uploadFile(file!, relativePath: relativePath)
                        
                        completion(file!)
                    }
                })
            }
        })
        
    }
    
//    func getImage(relativePath: String) -> UIImage?
//    {
//        if let imageData = getFile(relativePath)
//        {
//            if let image = UIImage(data: imageData)
//            {
//                return image
//            }
//        }
//        return placeholderImage
//    }
    
}