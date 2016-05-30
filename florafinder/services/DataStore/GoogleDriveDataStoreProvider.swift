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

class GoogleDriveDataStoreProvider: NSObject, DataStoreProviderProtocol
{
    private let ROOT_FOLDER_NAME = "TreeID"
    private var rootForderID: String?
    
    private let kKeychainItemName = "Drive API"
    private let kClientID = "630604644095-h99d0gh6sd3ast4tvd0rf23rh5p4kcn0.apps.googleusercontent.com"
    private let scopes = [kGTLAuthScopeDriveMetadataReadonly, kGTLAuthScopeDriveReadonly]
    private let service = GTLServiceDrive()
    private var isAuthenticated: Bool = false
    
    var delegate: GoogleDriveDataStoreProviderDelegate?
    var hostViewController: UIViewController?
    {
        return self.delegate?.autenticationViewControllerFor(self)
    }

    //MARK: - Initialisers
    
    init(delegate: GoogleDriveDataStoreProviderDelegate)
    {
        self.delegate = delegate
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
    }
    
    //MARK: - Authentication
    func authenticate(completion: ((isAuthenticated: Bool) -> Void)?)
    {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth
        {
            self.isAuthenticated = true
            completion?(isAuthenticated: true)
        }
        else
        {
            if let viewController = self.delegate?.autenticationViewControllerFor(self)
            {
                viewController.presentViewController(
                createAuthController(),
                animated: true,
                completion: { () in
                    completion?(isAuthenticated: self.isAuthenticated)
                    }
                )
            }
        }
    }
        
    private func createAuthController() -> GTMOAuth2ViewControllerTouch
    {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(self.handleAuth(_:finishedWithAuth:error:))
        )
    }
    
    // Handle completion of the authorization process, and update the Drive API
    // with the new credentials.
    @objc func handleAuth(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            print(error)
            return
        }
        
        isAuthenticated = true
        service.authorizer = authResult
        hostViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Delegate Methods
    
//    func getImage(path: String) -> UIImage?
//    {
//        return nil
//    }
//    
//    func getImageRecordsFromFolder(folderPath: String) -> [ImageRecord]
//    {
//        return [ImageRecord]()
//    }
//    
//    func getImageRecords(nameOrPattern: String) -> [ImageRecord]
//    {
//        return [ImageRecord]()
//    }
    
    func getImageRecords(nameOrPattern: String, recordFound: ((imageRecord: ImageRecord) -> Void))
    {
        if (isAuthenticated)
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
            
            service.executeQuery(query, completionHandler: { (ticket, fileList, error) in
                
                // Iterate over the results
                if let list = fileList as? GTLDriveFileList
                {
                    for item in list.files
                    {
                        if let file = item as? GTLDriveFile
                        {
                            let url = "https://www.googleapis.com/drive/v3/files/\(file.identifier)?alt=media"
                            
                            let fetcher = self.service.fetcherService.fetcherWithURLString(url as String)
                            
                            fetcher.beginFetchWithCompletionHandler({ (data, error) in
                                
                                if (data != nil)
                                {
                                    if let image = UIImage(data: data!)
                                    {
                                        // Let the callback know we have found an image
                                        let imageRecord = ImageRecord(image: image, metaData: nil)
                                        imageRecord.name = file.name
                                        recordFound(imageRecord: imageRecord)
                                    }
                                }
                            })
                        }
                    }
                }
            })
            
        }
    }

    func getFile(name: String, exportMimeType: String?, completion: ((file: NSData?) -> Void))
    {
        if (isAuthenticated)
        {
            let query = GTLQueryDrive.queryForFilesList()
            
            query.orderBy = "name"
            query.pageSize = 10
            query.q = "name = '\(name)'"
            query.fields = "nextPageToken, files(id, name)"
            
            service.executeQuery(query, completionHandler: { (ticket, fileList, error) in
                
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
                        
                        let fetcher = self.service.fetcherService.fetcherWithURLString(url as String)
                        
                        fetcher.beginFetchWithCompletionHandler({ (data, error) in
                            completion(file: data)
                        })
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
    
//    func getFile(name: String) -> NSData?
//    {
//        return nil
//    }
    
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
        if (isAuthenticated)
        {
            let query = GTLQueryDrive.queryForFilesList()
            
            query.orderBy = "name"
            query.pageSize = 10
            query.q = "name = '\(path)'"
            query.fields = "nextPageToken, files(id, name)"
            
            service.executeQuery(query, completionHandler: { (ticket, fileList, error) in
                
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