//
//  CacheDataStoreProvider.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 28/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class CacheDataStoreProvider: LocalDataStoreProvider
{
    override internal var rootFolder: NSURL
    {
        // Return the app's Cache directory
        return NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!)
    }
    
}