//
//  GoogleDriveDataStoreProviderDelegate.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 22/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol GoogleDriveDataStoreProviderDelegate {
    
    func autenticationViewControllerFor(provider: GoogleDriveDataStoreProvider) -> UIViewController
}