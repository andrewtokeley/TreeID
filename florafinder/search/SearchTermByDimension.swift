//
//  SearchTermByDimension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByDimension: SearchTerm
{
    let SEARCH_SIZE = "Size Search"
    
    var size: Measurement
    var leafDimensionService: LeafDimensionProtocol
    
    init(size: Measurement, leafDimensionService: LeafDimensionProtocol)
    {
        self.size = size
        self.leafDimensionService = leafDimensionService
    }
    
    override var description: String
    {
        return "Dimension: \(size.description)"
    }

    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        var searchResult = [SearchResult]()
        
        let allFlora = floraService.getAll()
        
        for flora in allFlora
        {
            // Work out how far away each dimension of self.size is away from the average width or height
            if let dimension = flora.leafUpper?.dimensions
            {
                // any flora with no dimensions defined or where the size is more than 2 standard deviations from the mean, get 0 relevance points
                var relevance = 0
                
                let deviation = leafDimensionService.deviationOfSizeFromDimension(dimension, size: self.size)
                
                let widthDev = deviation.width
                let lengthDev = deviation.length
                
                // unless otherwise defined, no relevance
                relevance = 0
                
                // more than 2 standard deviations from average leaf size...
                if (widthDev > 2 || lengthDev > 2)
                {
                    // ...but, if shape is still good then give some credit still
                    if let floraShape = flora.leafUpper?.dimensions?.shape
                    {
                        let searchShape = Measurement(width: self.size.width, length: self.size.length).shape
                        
                        if floraShape == searchShape
                        {
                            relevance = 1
                        }
                    }
                }
                // inside 2 standard deviations, so looking good
                else if (widthDev <= 2 && lengthDev <= 2)
                {
                    relevance = 2
                }
                
                let result = SearchResult(flora: flora, relevance: relevance)
                result.searchTypeDescription = SEARCH_SIZE
                
                if (relevance > 0)
                {
                    searchResult.append(result)
                }
            }
        }
        return searchResult
    }
}