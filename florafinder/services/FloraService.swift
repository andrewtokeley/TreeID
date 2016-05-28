//
//  FloraService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 8/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData

class FloraService:Service<Flora>, FloraServiceProtocol {
    
    override init(controller: CoreDataController, entityName: NSString) {
        super.init(controller: controller, entityName: entityName)
    }
    
    func addFlora(commonName: String) -> Flora
    {
        return addFlora(commonName, leafUpper: nil, leafUnder: nil, bark: nil)
    }
    
    func addFlora(commonName:String, leafUpper: Leaf?, leafUnder: Leaf?, bark: Bark?) -> Flora
    {
        let flora = add()
        
        flora.commonName = commonName
        if (leafUpper != nil)
        {
            flora.leafUpper = leafUpper
        }
        
        if (bark != nil)
        {
            flora.bark = bark
        }
        
        return flora
    }
 
    //MARK: - Super class passthroughs
    override func getAll() -> [Flora] {
        let sort = NSSortDescriptor(key: "commonName", ascending: true)
        return super.getObjects(nil, sortDescriptors: [sort])
    }
    override func getObjects(predicate: NSPredicate?) -> [Flora] {
        return super.getObjects(predicate)
    }
    override func getObjects(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [Flora] {
        return super.getObjects(predicate, sortDescriptors: sortDescriptors)
    }
    override func getObject(objectID: NSManagedObjectID) -> Flora?
    {
        return super.getObject(objectID)
    }
    override func deleteAll() -> Int {
        return super.deleteAll()
    }

    func getObject(commonName: String) -> Flora?
    {
        return super.getObjects(NSPredicate(format: "commonName ==[c] %@", commonName)).first
    }
    
    func descriptionListItems(flora: Flora) -> [DescriptionListItem]?
    {
        return nil
    }
    func deleteFlora(flora: Flora)
    {
        deleteObject(flora)
    }
    
    func similarTo(flora: Flora) -> [Flora]?
    {
        
        // build up search criteria to find similar flora
        
        // size
        //let dimensionSearch = SearchTermByDimension
        return Array(getAll().prefix(3))
    }
    
    func performSearch(searchTerms: [SearchTerm]) -> [SearchResult]?
    {
        return performSearch(searchTerms, strict: false)
    }
    
    func performSearch(searchTerms: [SearchTerm], strict: Bool) -> [SearchResult]?
    {
        var combinedResults = [SearchResult]()
        var nonNilSearchTerms = 0
        
        for searchTerm in searchTerms
        {
            if let results = searchTerm.execute(self)
            {
                if (searchTerm.strict)
                {
                    // remove items in the combinedResults set that are not included in this result set
                    combinedResults = combinedResults.filter({ (searchResult) in
                        
                        let isCombinedResultInStrictSet = results.filter({ (strictResult) in
                                // Return true if the combineResults item is in the strict result set
                                return strictResult.flora.objectID == searchResult.flora.objectID
                        }).count != 0
                        
                        // Returns true to keep this item in the combinedResults
                        return isCombinedResultInStrictSet
                    })
                }
                
                nonNilSearchTerms += 1
                for searchResult in results
                {
                    searchResult.addTo(&combinedResults)
                }
            }
        }
        
        // Remove any flora that didn't match any of the strict terms
        
//        
//        // if this is a strict search then only return flora that matched with all searchterms
//        if (strict)
//        {
//            combinedResults = combinedResults.filter({(result) in return result.hitCount == nonNilSearchTerms })
//        }
        
        // Order results
        return combinedResults.sort({(result1, result2) in return result1.relevance > result2.relevance })
    }
 
    func groupByCommonName(flora: [Flora]) -> [String: [Flora]]
    {
        var result = Dictionary<String, [Flora]>()
        
        let sections = ["A", "B", "C", "D", "E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        for firstLetter in sections
        {
            // get all the flora stating with this letter
            let group = super.getObjects(NSPredicate(format: "commonName BEGINSWITH %@", firstLetter))
            if (group.count > 0)
            {
                result[firstLetter] = group
            }
        }
        return result
        
    }
}