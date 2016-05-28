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
    
    func getImageRecords(nameOrPattern: String) -> [ImageRecord]
    {
        var results = [ImageRecord]()
        
        var imageURLs = NSBundle.mainBundle().URLsForResourcesWithExtension("jpg", subdirectory: nil)
        let pngURLs = NSBundle.mainBundle().URLsForResourcesWithExtension("png", subdirectory: nil)
        //let metaURLs = NSBundle.mainBundle().URLsForResourcesWithExtension("meta", subdirectory: nil)
        
        // Combine the images files
        if let _ = imageURLs
        {
            if let _ = pngURLs
            {
                imageURLs!.appendContentsOf(pngURLs!)
            }
        }
        else
        {
            imageURLs = pngURLs
        }
        
        // Find any matching files
        if let urls = imageURLs
        {
            for url in urls
            {
                if let filename = url.lastPathComponent
                {
                    if (filename.containsString(nameOrPattern))
                    {
                        // match!
                        
                        // see if there's any meta data too
                        let meta = getFile(filename + ".meta")
                        
                        if let image = UIImage(named: filename)
                        {
                            results.append(ImageRecord(image: image, metaData: meta))
                        }
                    }
                }
            }
        }
        
        return results
    }
    
    func getImageRecord(relativePath: String) -> ImageRecord?
    {
        if let image = getImage(relativePath)
        {
            // meta files have the same path as
            let metaPath = relativePath.stringByAppendingString(".meta")
            let meta = getFile(metaPath)
            
            return ImageRecord(image: image, metaData: meta)
        }
        return nil
    }
    
    /**
     Gets the specified image, either in the local cache, or in the datastore provider if not there.
     */
    
    func getFile(relativePath: String) -> NSData?
    {
        var file: NSData?
        
        if cacheDataStore.fileExists(relativePath)
        {
            file = cacheDataStore.getFile(relativePath)
        }
        else
        {
            if let masterFile = masterDataStoreProvider.getFile(relativePath)
            {
                // add file to cache
                cacheDataStore.uploadFile(masterFile, relativePath: relativePath)
                
                file = masterFile
            }
        }
        return file
    }
    
    func getImage(relativePath: String) -> UIImage?
    {
        if let imageData = getFile(relativePath)
        {
            if let image = UIImage(data: imageData)
            {
                return image
            }
        }
        return placeholderImage
    }
    
}