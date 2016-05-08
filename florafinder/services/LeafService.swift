//
//  LeafService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 10/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class LeafService: Service<Leaf>, LeafServiceProtocol {
    
    override init(controller: CoreDataController, entityName: NSString) {
        super.init(controller: controller, entityName: entityName)
    }
    
    func addLeaf(dimension:LeafDimension?, edge: LeafEdgeType?, color: LeafColorType?, texture: LeafTextureType?) -> Leaf
    {
        let leaf = add()
        leaf.edgeType = edge
        leaf.colorType = color
        leaf.dimensions = dimension
        leaf.textureType = texture
        
        return leaf
    }
    
}