//
//  GoogleDriveDataStoreProvider.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 22/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import GoogleAPIClient
import GTMOAuth2

enum GoogleDriveDataStoreException: ErrorType
{
    case Unauthorized
}

class GoogleDriveDataStoreProvider: NSObject, DataStoreProviderProtocol
{
    private let ROOT_FOLDER_NAME = "TreeID"
    private var rootForderID: String?
    private var authenticationService: AuthenticationServiceProtocol
    
    var delegate: GoogleDriveDataStoreProviderDelegate?
    var hostViewController: UIViewController?
    {
        return self.delegate?.autenticationViewControllerFor(self)
    }

    
    //MARK: - Initialisers
    
    init(service: AuthenticationServiceProtocol)
    {
        self.authenticationService = service
        super.init()
    }
    
    var service: GTLServiceDrive?
    {
        return authenticationService.context as? GTLServiceDrive
    }
    
//    var isAuthenticated: Bool
//    {
//        let service = authenticationService.context as? GTLServiceDrive
//        if let authorizer = service.authorizer, canAuth = authorizer.canAuthorize where canAuth
//        {
//            return true
//        }
//        return false
//    }
    
    //MARK: - Delegate Methods
    
    func getImageRecords(nameOrPattern: String, recordFound: ((imageRecord: ImageRecord, index: Int, count: Int) -> Void))
    {
        if (authenticationService.isAuthenticated)
        {
            let query = GTLQueryDrive.queryForFilesList()
            
            query.orderBy = "name"
            query.pageSize = 10
            let queryString = "name contains '\(nameOrPattern)'"
            
//            if inFolder != nil
//            {
//                queryString += " and \(inFolder) in parents"
//            }
            
            query.q = queryString
            query.fields = "nextPageToken, files(id, name)"
            
            service?.executeQuery(query, completionHandler: { (ticket, fileList, error) in
                
                // Iterate over the results
                var index = 0
                if let list = fileList as? GTLDriveFileList
                {
                    let count = list.files.count
                    for item in list.files
                    {
                        
                        if let file = item as? GTLDriveFile
                        {
                            let url = "https://www.googleapis.com/drive/v3/files/\(file.identifier)?alt=media"
                            
                            if let fetcher = self.service?.fetcherService.fetcherWithURLString(url as String)
                            {
                                fetcher.beginFetchWithCompletionHandler({ (data, error) in
                                    
                                    if (data != nil)
                                    {
                                        if let image = UIImage(data: data!)
                                        {
                                            // Let the callback know we have found an image
                                            let imageRecord = ImageRecord(image: image, metaData: nil)
                                            imageRecord.name = file.name
                                            recordFound(imageRecord: imageRecord, index: index, count:  count)
                                        }
                                    }
                                })
                            }
                        }
                        index += 1
                        
                    }
                }
            })
            
        }
    }

    func getFile(name: String, exportMimeType: String?, completion: ((file: NSData?) -> Void))
    {
        if (authenticationService.isAuthenticated)
        {
            let query = GTLQueryDrive.queryForFilesList()
            
            query.orderBy = "name"
            query.pageSize = 10
            query.q = "name = '\(name)'"
            query.fields = "nextPageToken, files(id, name)"
            
            service?.executeQuery(query, completionHandler: { (ticket, fileList, error) in
                
                // just return the first result
                if let list = fileList as? GTLDriveFileList
                {
                    if let file = list.files.first as? GTLDriveFile
                    {
                        var url: String
                        
                        if let mimeType = exportMimeType
                        {
                            url = "https://www.googleapis.com/drive/v3/files/\(file.identifier)/export?alt=media&mimeType=\(mimeType)"
                        }
                        else
                        {
                            url = "https://www.googleapis.com/drive/v3/files/\(file.identifier)?alt=media"
                        }
                        
                        if let fetcher = self.service?.fetcherService.fetcherWithURLString(url as String)
                        {
                            fetcher.beginFetchWithCompletionHandler({ (data, error) in
                                completion(file: data)
                            })
                        }
                    }
                }
            })
            
        }

    }
    
    func getFile(name: String, completion: ((file: NSData?) -> Void))
    {
        // Hack to avoid having to add to DataStoreProciderProtocol for an export option
        if name.lowercaseString.containsString("register")
        {
            getFile(name, exportMimeType: "text/csv", completion: completion)
        }
        else
        {
            getFile(name, exportMimeType: nil, completion: completion)
        }
    }
    
    func uploadFile(file: NSData, relativePath: String) -> NSURL?
    {
        return nil
    }
    
    func uploadImage(image: UIImage, relativePath: String) -> NSURL?
    {
        return nil
    }
    
    func fileExists(path: String, completion: (Bool) -> Void)
    {
        if (authenticationService.isAuthenticated)
        {
            let query = GTLQueryDrive.queryForFilesList()
            
            query.orderBy = "name"
            query.pageSize = 10
            query.q = "name = '\(path)'"
            query.fields = "nextPageToken, files(id, name)"
            
            service?.executeQuery(query, completionHandler: { (ticket, fileList, error) in
                
                var ok = (error == nil)
                if ok
                {
                    // ensure there's a match
                    if let list = fileList as? GTLDriveFileList
                    {
                        if let _ = list.files.first as? GTLDriveFile
                        {
                            ok = true
                        }
                    }
                }
                completion(ok)
            })
        }
    }
    
    func deleteAll(completion: (Bool) -> Void) {
        completion(false)
    }
    
}