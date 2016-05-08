//
//  FloraSearchResult.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 8/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

/**
 This class represents the search results for a single Flora. A SearchResult can be the result of performing many different types of searches. The details about how each type of search result impacted this search result, can be explored through the searchTermResultDetails property.
 */
class SearchResult: NSObject
{
    var flora: Flora
    var relevance: Int
    var hitCount: Int

    /**
     Returns user readable descriptions of the search result. Useful for seeing why a result did or did not match
     */
    var searchTermResultDetails: [String] = []
    
    /** 
     set this value based on the sort of search being done. This allows search results to be grouped by search type.
     */
    var searchTypeDescription: String?
    
    init(flora: Flora, relevance: Int)
    {
        self.flora = flora
        self.relevance = relevance
        self.hitCount = 0
    }
    
    /**
    Adds current instance to a master array of search results. If a search result exists for the same flora it is merged with that result, with the relevances being added together and a record added to the searchTermResultDetails array. Otherwise, the instance is added to the end of the array as a new result. This method also tracks the number of times a flora has been matched in a search
    */
    func addTo(inout searchResults: [SearchResult]) //, intersectionOnly: Bool)
    {
        // if self is part of the searchResults then increase it's relevance
        let objectID = self.flora.objectID
        let match = searchResults.filter( { (item) in item.flora.objectID == objectID })
        if (match.count > 0)
        {
            // merge the current instance with the other result for the same Flora
            match.first!.relevance += self.relevance
            match.first!.hitCount += 1 // this item has matched again so bump hit count
            match.first!.searchTermResultDetails.appendContentsOf(self.searchTermResultDetails)
        }
        else
        {
            // First time this a search result added for this flora
            self.hitCount = 1
            searchResults.append(self)
        }
        
    }
}