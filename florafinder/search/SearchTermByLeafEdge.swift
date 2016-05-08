//
//  SearchTermByLeafEdge.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByLeafEdge: SearchTermByLookupType
{
    var leafEdgeType: LeafEdgeType
    
    init(leafEdgeType: LeafEdgeType)
    {
        self.leafEdgeType = leafEdgeType
    }
    
    override var lookupName: String
    {
        return "Leaf Edge"
    }
    
    override var lookupValue: String
    {
        return self.leafEdgeType.name!
    }
    
    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        return super.getResults(floraService, predicate: NSPredicate(format: "leafUpper.edgeType=%@", self.leafEdgeType))
    }
}