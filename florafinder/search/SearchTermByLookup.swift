//
//  SearchTermByLookup.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 31/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByLookupType: SearchTerm
{
    
    var lookupName: String
    {
        preconditionFailure("Must override getter")
    }
    
    var lookupValue: String
    {
        preconditionFailure("Must override getter")
    }
    
    override var description: String
    {
        return "\(lookupName): \(lookupValue)"
    }
    
    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]? {
        preconditionFailure("Must override")
    }
    
    internal func getResults(floraService:FloraServiceProtocol, predicate: NSPredicate) -> [SearchResult]
    {
        var searchResult = [SearchResult]()
        
        for flora in floraService.getObjects(predicate)
        {
            let result = SearchResult(flora: flora, relevance: 1)
            result.searchTypeDescription = "\(lookupName) Search"
            result.searchTermResultDetails.append("\(lookupName) Search: \(flora.commonName!) matched on \(lookupValue)")
            searchResult.append(result)
        }
        return searchResult
    }
}