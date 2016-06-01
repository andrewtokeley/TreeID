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
        if let url = NSBundle.mainBundle().URLForResource(name, withExtension: nil)
        {
            completion(file: NSData(contentsOfURL: url))
        }
        else
        {
            completion(file: nil)
        }
    }
    
//    func getFile(name: String) -> NSData? {
//        
//        if let url = NSBundle.mainBundle().URLForResource(name, withExtension: nil)
//        {
//            return NSData(contentsOfURL: url)
//        }
//        return nil
//    }
    
//    func getImage(name: String) -> UIImage?
//    {
//        return UIImage(named: name)
//    }
    func fileExists(path: String, completion: (Bool) -> Void)
    {
        if let _ = NSBundle.mainBundle().URLForResource(path, withExtension: nil)
        {
            completion(true)
        }
        else
        {
            completion(false)
        }
    }
    
//    func getImageRecordsFromFolder(folderPath: String) -> [ImageRecord]
//    {
//        fatalError("not implemeneted")
//    }
//    
//    func getImageRecords(nameOrPattern: String) -> [ImageRecord]
//    {
//        return [ImageRecord]()
//    }
    
    func getImageRecords(nameOrPattern: String, recordFound: ((imageRecord: ImageRecord, index: Int, count: Int) -> Void))
    {
        // get the URLs for all images in the bundle
        var imageURLs = NSBundle.mainBundle().URLsForResourcesWithExtension("jpg", subdirectory: nil)
        let pngURLs = NSBundle.mainBundle().URLsForResourcesWithExtension("png", subdirectory: nil)
        
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
        var matchingFiles = [String]()
        
        if let urls = imageURLs
        {
            for url in urls
            {
                if let filename = url.lastPathComponent
                {
                    if (filename.containsString(nameOrPattern))
                    {
                        // match!
                        matchingFiles.append(filename)
                    }
                }
            }
        }
        
        // Process
        let count = matchingFiles.count
        var index = 0
        for filename in matchingFiles
        {
            // see if there's any meta data too
            getFile(filename + ".meta", completion: {
                (file) in
                
                let meta = file
                
                if let image = UIImage(named: filename)
                {
                    // Simulate a 2 second delay before returning the result
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
                    dispatch_after(time, dispatch_get_main_queue())
                    {
                        // let the callback know we've found an image
                        let imageRecord = ImageRecord(image: image, metaData: meta)
                        imageRecord.name = filename
                        recordFound(imageRecord: imageRecord, index: index, count: count)
                        index += 1
                    }
                    
                }
            })
        }

    }

    func uploadFile(file: NSData, relativePath: String) -> NSURL?
    {
        fatalError("not implemented")
    }
    
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    {
        fatalError("not implemented")
    }

    func deleteAll(completion: (Bool) -> Void)
    {
        fatalError("not implemented")
    }
}