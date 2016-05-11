//
//  SearchTermByDimension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByDimension: SearchTermProtocol
{
    let SEARCH_SIZE = "Size Search"
    let SEARCH_SHAPE = "Shape Search"
    
    var size: Measurement?
    var shape: LeafShapeEnum?
    
    var tolerance: Float = 0
    var leafDimensionService: LeafDimensionProtocol?
    
    init(size: Measurement?, tolerance: Float)
    {
        self.size = nil
        self.size = size
        self.tolerance = tolerance
    }
    
    convenience init(shape: LeafShapeEnum)
    {
        self.init(size: nil, tolerance: 0)
        self.shape = shape
    }
    
    func execute(floraService: FloraServiceProtocol) -> [SearchResult]? {
        
        if let _ = self.shape
        {
            return shapeSearch(floraService)
        }
        return sizeSearch(floraService)
    }
    
    func shapeSearch(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        guard self.shape != nil else {return [SearchResult]() }
        
        var searchResult = [SearchResult]()
        
        let allFlora = floraService.getAll()
        
        for flora in allFlora
        {
            if (flora.leafUpper?.dimensions?.shape == self.shape!)
            {
                let result = SearchResult(flora: flora, relevance: 1)
                searchResult.append(result)
                result.searchTypeDescription = SEARCH_SHAPE
            }
        }
        return searchResult
    }
    
    func sizeSearch(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        guard self.size != nil else {return [SearchResult]() }
        
        var searchResult = [SearchResult]()
        
        let allFlora = floraService.getAll()
        
        for flora in allFlora
        {
            if let service = self.leafDimensionService
            {
                // Work out how far away each dimension of self.size is away from the average width or height
                if let dimension = flora.leafUpper?.dimensions
                {
                    // any flora with no dimensions defined or where the size is more than 2 standard deviations from the mean, get 0 relevance points
                    var relevance = 0
                    
                    let deviation = service.deviationOfSizeFromDimension(dimension, size: self.size!)
                    
                    let widthDev = deviation.width
                    let lengthDev = deviation.length
                    
                    if (widthDev > 2 || lengthDev > 2) { relevance = 0 }
                    else if (widthDev <= 2 && lengthDev <= 2) { relevance = 1 }
                    
                    let result = SearchResult(flora: flora, relevance: relevance)
                    result.searchTypeDescription = SEARCH_SIZE
                    
                    if (relevance > 0)
                    {
                        searchResult.append(result)
                    }
                }
            }
        }
        return searchResult
    }
}