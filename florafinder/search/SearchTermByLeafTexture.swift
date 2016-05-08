//
//  SearchTermByLeafTexture.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTermByLeafTexture: SearchTermByLookupType
{
    var leafTextureType: LeafTextureType
    
    init(leafTextureType: LeafTextureType)
    {
        self.leafTextureType = leafTextureType
    }
    
    override var lookupName: String
    {
        return "Leaf Texture"
    }
    
    override var lookupValue: String
    {
        return self.leafTextureType.name!
    }
    
    override func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        return super.getResults(floraService, predicate: NSPredicate(format: "leafUpper.textureType=%@", self.leafTextureType))
    }
}