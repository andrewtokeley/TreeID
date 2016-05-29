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
     Returns an image from the store
    */
    func getImage(path: String) -> UIImage?
    func getImageRecordsFromFolder(folderPath: String) -> [ImageRecord]
    
    func getImageRecords(nameOrPattern: String) -> [ImageRecord]
    func getImageRecords(nameOrPattern: String, inFolder: String?, completion: ((imageRecords: [ImageRecord]) -> Void))
    
    func getFile(path: String) -> NSData?
    
    func getFile(path: String, completion: ((file: NSData?) -> Void))
    
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    func uploadFile(file: NSData, relativePath: String) -> NSURL?
    
    func fileExists(path: String) -> Bool
    func deleteAll() throws -> Bool
}