//
//  LeafServiceProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 10/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol LeafServiceProtocol
{
    func addLeaf(dimension:LeafDimension?, edge: LeafEdgeType?, color: LeafColorType?, texture: LeafTextureType?) -> Leaf
}