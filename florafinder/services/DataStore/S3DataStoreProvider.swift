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
    
    func getImageRecords(nameOrPattern: String, recordFound: ((imageRecord: ImageRecord, index: Int, count: Int) -> Void)) {
        //
    }

    func getFile(path: String, completion: ((file: NSData?) -> Void))
    {
    }
    
    func uploadFile(file: NSData, relativePath: String) -> NSURL?
    {
        return nil
    }
    
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    {
        return nil
    }

    func fileExists(path: String, completion: (Bool) -> Void) {
        completion(false)
    }
    
    func deleteAll(completion: (Bool) -> Void)
    {
        completion(true)
    }
}