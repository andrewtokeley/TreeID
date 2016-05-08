//
//  SearchTermByFlowerColor.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByFlowerColor: SearchTermByLookupType
{
    var flowerColorType: FlowerColorType
    
    init(flowerColorType: FlowerColorType)
    {
        self.flowerColorType = flowerColorType
    }
    
    override var lookupName: String
    {
        return "Flower Color"
    }
    
    override var lookupValue: String
    {
        return self.flowerColorType.name!
    }
    
    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        return super.getResults(floraService, predicate: NSPredicate(format: "flowerColor=%@", self.flowerColorType))
    }
}