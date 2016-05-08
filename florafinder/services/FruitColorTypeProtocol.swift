//
//  FruitColorTypeProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 29/02/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol FruitColorTypeProtocol
{
    func reset()
    func syncEnumerationsToDatastore()
    
    func getAll() -> [FruitColorType]
    func getObjects(predicate: NSPredicate?) -> [FruitColorType]
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [FruitColorType]
    func getObject(name: String) -> FruitColorType?
    func getObject(type: FruitColorTypeEnum) -> FruitColorType?
    
    func deleteAll() -> Int
}