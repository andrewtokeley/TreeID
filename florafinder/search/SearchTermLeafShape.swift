//
//  SearchTermLeafRatio.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 23/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermLeafShape: SearchTerm
{
    let SEARCH_SHAPE = "Shape Search"
    
    var shape: LeafShapeEnum
    
    init(shape: LeafShapeEnum)
    {
        self.shape = shape
    }
    
    override var description: String
    {
        return "Shape: \(shape.displayName)"
    }
    
    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        var searchResult = [SearchResult]()
        
        let allFlora = floraService.getAll()
        
        for flora in allFlora
        {
            if (flora.leafUpper?.dimensions?.shape == self.shape)
            {
                let result = SearchResult(flora: flora, relevance: 1)
                searchResult.append(result)
                result.searchTypeDescription = SEARCH_SHAPE
            }
        }
        return searchResult
    }
}