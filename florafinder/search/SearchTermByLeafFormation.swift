//
//  SearchTermByLeafFormation.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByLeafFormation: SearchTermByLookupType
{
    var leafFormationType: LeafFormationType
    
    init(leafFormationType: LeafFormationType)
    {
        self.leafFormationType = leafFormationType
    }
    
    override var lookupName: String
    {
        return "Leaf Formation"
    }
    
    override var lookupValue: String
    {
        return self.leafFormationType.name!
    }
    
    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        return super.getResults(floraService, predicate: NSPredicate(format: "leafUpper.formationType=%@", self.leafFormationType))
    }
}