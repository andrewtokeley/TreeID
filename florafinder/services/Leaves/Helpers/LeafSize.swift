//
//  LeafSize.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 23/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class LeafSize
{
    var width: Float
    var length: Float
 
    init(width: Float, length: Float)
    {
        self.width = width
        self.length = length
    }
    
    var ratio: Float
    {
        return length/width
    }
    
    var shape: LeafShapeEnum
    {
        if (length <= 2 && width < 2)
        {
            return LeafShapeEnum.Small
        }
        else if (ratio > LeafShapeEnum.Narrow.ratio && length > 5)
        {
            return LeafShapeEnum.Narrow
        }
        else if (ratio > LeafShapeEnum.Regular.ratio)
        {
            return LeafShapeEnum.Regular
        }
        else if (ratio > LeafShapeEnum.Broad.ratio && width > 3)
        {
            return LeafShapeEnum.Broad
        }
        
        // default to regular
        return LeafShapeEnum.Regular
    }
}