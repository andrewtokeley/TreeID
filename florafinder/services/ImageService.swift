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
    
    var placeholderImage: UIImage
    {
        if let image = UIImage(named: "placeholder.png")
        {
            return image
        }
        return UIImage()
    }
    
    /**
     Gets the specified image, either in the local cache, or in the datastore provider if not there.
     */
    func getImage(relativePath: String) -> UIImage?
    {
        if cacheDataStore.fileExists(relativePath)
        {
            return cacheDataStore.getImage(relativePath)
        }
        else
        {
            if let image = masterDataStoreProvider.getImage(relativePath)
            {
                // add image to cache
                cacheDataStore.uploadImage(image, relativePath: relativePath)
                
                return image
            }
        }
        
        // if all else fails return a placeholder image
        return placeholderImage
    }
    
}