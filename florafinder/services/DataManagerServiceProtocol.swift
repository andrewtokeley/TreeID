//
//  DataManagerServiceProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 14/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol DataManagerServiceProtocol {
    /**
     Destroys all data from the database and rebuilds all default data structures (e.g. lookup lists)
     */
    func rebuildDatabase() throws
    
}