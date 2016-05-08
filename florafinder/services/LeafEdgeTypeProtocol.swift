//
//  LeafEdgeProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol LeafEdgeTypeProtocol
{
    func reset()
    func syncEnumerationsToDatastore()
    
    func getAll() -> [LeafEdgeType]
    func getObjects(predicate: NSPredicate?) -> [LeafEdgeType]
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [LeafEdgeType]
    func getObject(name: String) -> LeafEdgeType?
    func getObject(type: LeafEdgeTypeEnum) -> LeafEdgeType?
}