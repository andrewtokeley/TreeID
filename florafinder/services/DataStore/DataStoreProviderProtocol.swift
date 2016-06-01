//
//  RemoteStoreProviderProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 27/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol DataStoreProviderProtocol {
    
    /**
     Requests an array of ImageRecords based on a file name or pattern.
     
     - parameter nameOrPattern: the name of the file(s) being requested, or a pattern that will match to the beginning of the path names. e.g. search for "hello", would match on "helloworld.jpg" or "hello.txt" but not on "sayhello.png".
     - parameter inFolder:
     - parameter completion: callback method that accepts a single parameter for the resulting file. If no file is found the callback parameter will be nil.
     */
    func getImageRecords(nameOrPattern: String, recordFound: ((imageRecord: ImageRecord, index: Int, count: Int) -> Void))
    
    /**
     Requests a single file, by path, returning the result as callback.
     
     - parameter path: of the file to be searched. The path is relative to the DataStore's root directory
     - parameter completion: callback method that accepts a single parameter for the resulting file. If no file is found the callback parameter will be nil.
     */
    func getFile(path: String, completion: ((file: NSData?) -> Void))
    
    /**
     Uploads an image to the DataStore.
     
     - parameter image: UIImage to be uploaded
     - parameter relativePath: the relativePath, including the file name, to upload the image to
     */
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    
    /**
     Uploads a file to the DataStore.
     
     - parameter file: NSData representation of the file to be uploaded
     - parameter relativePath: the relativePath, including the file name, to upload the image to
     */
    func uploadFile(file: NSData, relativePath: String) -> NSURL?

    /**
     Request to determine whether a file exists in the DataStore
     
     - parameter path: relativePath, incuding file name, of the file to search for
     - parameter completion: callback method that accepts a Bool that will be set to true if the file exists, otherwise false.
     */
    func fileExists(path: String, completion: (Bool) -> Void)
    
    // Optional
    func deleteAll(completion: (Bool) -> Void)
}