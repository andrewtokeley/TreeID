//
//  FloraServiceProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 8/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData

protocol FloraServiceProtocol
{
    func addFlora(commonName: String) -> Flora
    func addFlora(commonName:String, leafUpper: Leaf?, leafUnder: Leaf?, bark: Bark?) -> Flora
    func deleteFlora(flora: Flora)
    func deleteAll() -> Int
 
    func getAll() -> [Flora]
    func getObject(objectID: NSManagedObjectID) -> Flora?
    func getObject(commonName: String) -> Flora?
    func getObjects(predicate: NSPredicate?) -> [Flora]
    func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [Flora]

    //func getObject(commonName: String) -> Flora?
    
    func groupByCommonName(flora: [Flora]) -> [String: [Flora]]
    func descriptionListItems(flora: Flora) -> [DescriptionListItem]?
    
    // Search
    func performSearch(searchTerms: [SearchTermProtocol?]) -> [SearchResult]?
    func performSearch(searchTerms: [SearchTermProtocol?], strict: Bool) -> [SearchResult]?
}