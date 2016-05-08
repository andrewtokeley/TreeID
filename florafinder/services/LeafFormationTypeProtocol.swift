//
//  LeafFormationProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 18/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol LeafFormationTypeProtocol {
    
    func reset()
    func syncEnumerationsToDatastore()
    
    func getAll() -> [LeafFormationType]
    func getObjects(predicate: NSPredicate?) -> [LeafFormationType]
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafFormationType]
    func getObject(name: String) -> LeafFormationType?
    func getObject(type: LeafFormationTypeEnum) -> LeafFormationType?
    
}