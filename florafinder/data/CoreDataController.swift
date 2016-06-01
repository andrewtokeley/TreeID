//
//  CoreData.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 6/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData

enum CoreDataControllerError: ErrorType {
    case DataModelNotFound
    case InsufficientFunds(coinsNeeded: Int)
    case OutOfStock
}

/**
 Provides access to Core Data functionality
*/
class CoreDataController: NSObject {

    private var _coordinator: NSPersistentStoreCoordinator?
    private var _managedObjectContext: NSManagedObjectContext?
    
    //MARK: - Initialisers

    /**
    Creates a new CoreDataController instance
    
    - Parameters:
        - storeName: the name of the store
        - dataModelName: the name of the data model
    - Returns: not applicable
    - Throws: `CoreDataControllerError.DataModelNotFound` if data model file not found
    */
    init(dataModelName:NSString, storeName: NSString) throws
    {
        self.dataModelName = dataModelName
        self.storeName = storeName;
        
        super.init()
        
        // check validity of controller
        
        // the compiled data model must exist otherwise we're screwed
        guard (NSBundle.mainBundle().URLForResource(dataModelName as String, withExtension: "momd") != nil) else
        {
            throw CoreDataControllerError.DataModelNotFound
        }
    }

    //MARK: - Properties
    
    /**
    Read-only property that returns the URL to the application's Documents directory. This is where the database store will be saved
    */
    var applicationDocumentsDirectory: NSURL
    {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }

    /**
    Returns or sets the name given to the data model. This name should match the name of your *.xcdatamodeld file.
    */
    var dataModelName: NSString
    
    /**
    Returns or sets the name given to the data store.
    */
    var storeName: NSString = ""

    /**
     Read-only property that returns the full path to the database store
     */
    var  storeURL: NSURL
    {
        return self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.storeName).sqlite")
    }

    /** Set to true to force self.persistentStoreCoordinator to return a new coordinator
     */
    var needsUpdateManagedObjectContext: Bool = true
    
    /** 
     Returns the managed object context for the application.
    */
    var managedObjectContext: NSManagedObjectContext
    {
        if (needsUpdateManagedObjectContext)
        {
            _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
            _managedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
            needsUpdateManagedObjectContext = false
        }
        
        // We can assume that needsUpdateManagdObjectContext is initialised to true so that at this point _managedObjectContext is never nil
        return _managedObjectContext!
    }

    /**
     Returns the `ManagedObjectModel` associated with the specified dataModel.
     */
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.dataModelName as String, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    /** Set to true to force self.persistentStoreCoordinator to return a new coordinator
    */
    var needsUpdateStoreCoordinator:Bool = true

    /**
    The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
     */
    var persistentStoreCoordinator:NSPersistentStoreCoordinator?
    {
        if (needsUpdateStoreCoordinator)
        {
            // Create the coordinator and store
            _coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let failureReason = "There was an error creating or loading the application's saved data."
            do {
                try _coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL, options: nil)
                needsUpdateStoreCoordinator = false
            } catch {
                // Report any error we got.
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                
                dict[NSUnderlyingErrorKey] = error as NSError
                let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                abort()
            }
        }
        return _coordinator
    }
    
    //MARK: - Functions
    
    /**
    Rolls back unsaved changes made on the `managedObjectContext`
    */
    func rollback()
    {
        self.managedObjectContext.rollback()
    }

    /**
     Save unsaved changes made on the `managedObjectContext`
     
     - Throws: propogates any exceptions thrown by managedObjectContext.save()
     */

    func save() throws
    {
        // propogates the error up the chain
            try self.managedObjectContext.save()
    }
    
    func resetDatastore() throws -> Bool
    {
        var success: Bool = false
        
        self.managedObjectContext.lock()
        self.managedObjectContext.reset()
        
        if let store = self.persistentStoreCoordinator?.persistentStores.last
        {
            do
            {
                try self.persistentStoreCoordinator?.removePersistentStore(store)
                needsUpdateStoreCoordinator = true
                needsUpdateManagedObjectContext = true
                
                try NSFileManager.defaultManager().removeItemAtPath(storeURL.path!)
                
                // Now recreate the store - necessary?
                self.managedObjectContext.unlock()
                
                success = true
            }
            catch
            {
                // TODO: Log
                success = false
            }
        }
        return success
    }
    
    // Remove the Persistant Data Store, removing all data, and recreated
//    - (BOOL)resetDatastore
//        {
//            [_managedObjectContext lock];
//            [_managedObjectContext reset];
//            NSPersistentStore *store = [[_persistentStoreCoordinator persistentStores] lastObject];
//            BOOL resetOk = NO;
//            
//            if (store)
//            {
//                NSURL *storeUrl = store.URL;
//                NSError *error;
//                
//                if ([_persistentStoreCoordinator removePersistentStore:store error:&error])
//                {
//                    _persistentStoreCoordinator = nil;
//                    _managedObjectContext = nil;
//                    
//                    if (![[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:&error])
//                    {
//                        NSLog(@"\nresetDatastore. Error removing file of persistent store: %@",
//                            [error localizedDescription]);
//                        resetOk = NO;
//                    }
//                    else
//                    {
//                        //now recreate persistent store
//                        [[self managedObjectContext] unlock];
//                        resetOk = YES;
//                    }
//                }
//                else
//                {
//                    NSLog(@"\nresetDatastore. Error removing persistent store: %@",
//                        [error localizedDescription]);
//                    resetOk = NO;
//                }
//                return resetOk;
//            }
//            else
//            {
//                NSLog(@"\nresetDatastore. Could not find the persistent store");
//                return resetOk;
//            }
}

