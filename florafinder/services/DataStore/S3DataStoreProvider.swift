//
//  S3RemoteStoreProvider.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 27/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class S3DataStoreProvider: DataStoreProviderProtocol
{
    
    init (key: String, baseURL: NSURL)
    {
        // or whatever we need to set this up
    }
    
    func getImage(path: String) -> UIImage?
    {
        return nil
    }
    
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    {
        return nil
    }

    func fileExists(path: String) -> Bool
    {
        return false
    }
    
    func deleteAll() -> Bool
    {
        return false
    }
}