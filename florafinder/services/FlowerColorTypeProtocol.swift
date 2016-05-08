//
//  FlowerColorTypeProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 13/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol FlowerColorTypeProtocol
{
    func reset()
    func syncEnumerationsToDatastore()
    
    func getAll() -> [FlowerColorType]
    func getObjects(predicate: NSPredicate?)  -> [FlowerColorType]
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)  -> [FlowerColorType]
    func getObject(name: String)  -> FlowerColorType?
    func getObject(type: FlowerColorTypeEnum)  -> FlowerColorType?
    
    func deleteAll() -> Int
}