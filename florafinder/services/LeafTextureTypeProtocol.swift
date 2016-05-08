//
//  LeafTextureType.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol LeafTextureTypeProtocol
{
    func reset()
    func syncEnumerationsToDatastore()
    
    func getAll() -> [LeafTextureType]
    func getObjects(predicate: NSPredicate?) -> [LeafTextureType]
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafTextureType]
    func getObject(name: String) -> LeafTextureType?
    func getObject(type: LeafTextureTypeEnum) -> LeafTextureType?
}