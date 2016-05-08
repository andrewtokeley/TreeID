//
//  LeafColorTypeProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol LeafColorTypeProtocol
{
    func reset()
    func syncEnumerationsToDatastore()
    
    func getAll()  -> [LeafColorType]
    func getObjects(predicate: NSPredicate?)  -> [LeafColorType]
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafColorType]
    func getObject(name: String)  -> LeafColorType?
    func getObject(type: LeafColorTypeEnum)  -> LeafColorType?
}