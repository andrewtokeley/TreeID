//
//  SearchTermByFruitColor.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByFruitColor: SearchTermByLookupType
{
    var fruitColorType: FruitColorType
    
    init(fruitColorType: FruitColorType)
    {
        self.fruitColorType = fruitColorType
    }
    
    override var lookupName: String
    {
        return "Fruit Color"
    }

    override var lookupValue: String
    {
        return self.fruitColorType.name!
    }

    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        return super.getResults(floraService, predicate: NSPredicate(format: "fruitColor=%@", self.fruitColorType))
    }
}