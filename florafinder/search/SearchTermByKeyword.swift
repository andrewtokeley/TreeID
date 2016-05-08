//
//  SearchTermByKeyword.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 31/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByKeyword: SearchTermProtocol
{
    let SEARCH_TYPE = "Keyword Search"
    
    var keyword: String
    var floraService: FloraServiceProtocol?
    
    init(keyword: String)
    {
        self.keyword = keyword
    }
    
    func execute(floraService: FloraServiceProtocol) -> [SearchResult]? {
        
        self.floraService = floraService
        
        var searchResult = [SearchResult]()
        
        for flora in floraService.getAll()
        {
            let searchPhrase = getSearchPhrase(flora)
            
            // relevance is based on how many times the keyword matches
            let count = searchPhrase.numberOfMatches(keyword)
            
            let result = SearchResult(flora: flora, relevance: 0)
            result.searchTypeDescription = SEARCH_TYPE
            if (count > 0)
            {
                // match!
                result.relevance = count
                result.searchTermResultDetails.append("The keyword, '\(self.keyword)' matched \(count) times")
            }
            else
            {
                result.searchTermResultDetails.append("The keyword, '\(self.keyword)' did not match on anything")
            }
            searchResult.append(result)
        }
        
        return searchResult
    }
    
    func getSearchPhrase(flora: Flora) -> String
    {
        let separator = ":"
        var result = ""
        
        if let text = flora.commonName { result.appendContentsOf(text + separator) }
        if let text = flora.leafUpper?.edgeType?.name { result.appendContentsOf(text + separator) }
        if let text = flora.leafUpper?.colorType?.name { result.appendContentsOf(text + separator) }
        if let text = flora.leafUpper?.textureType?.name { result.appendContentsOf(text + separator) }
        
        return result
    }
    
//    private func getResults(floraService: FloraServiceProtocol, predicate: NSPredicate) -> [SearchResult]
//    {
//        var searchResult = [SearchResult]()
//        
//        let results = floraService.getFlora(predicate)
//        for flora in results
//        {
//            searchResult.append(SearchResult(flora: flora, relevance: 1))
//        }
//        
//        return searchResult
//    }

}