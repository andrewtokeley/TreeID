//
//  Measurement.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 23/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

struct Measurement: Equatable
{
    var width: Float
    var length: Float
    
    var ratio: Float
    {
        guard length != 0 else { return 0 }
        
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
        return LeafShapeEnum.Regular
    }
    
    /**
     Returns Measurement in format "w - h"
     */
    var description: String
    {
        let widthFormat = (width % 1 == 0) ? "%.0f" : "%.01f"
        let widthString = String(format: widthFormat, width)
        let lengthFormat = (length % 1 == 0) ? "%.0f" : "%.01f"
        let lengthString = String(format: lengthFormat, length)
        return "\(widthString)-\(lengthString)"
    }
    
    func descriptionWithOtherMeasure(measurement: Measurement) -> String
    {
        var widthFormat = (width % 1 == 0) ? "%.0f" : "%.01f"
        let widthFromString = String(format: widthFormat, width)
        var lengthFormat = (length % 1 == 0) ? "%.0f" : "%.01f"
        let lengthFromString = String(format: lengthFormat, length)
        
        widthFormat = (measurement.width % 1 == 0) ? "%.0f" : "%.01f"
        let widthToString = String(format: widthFormat, measurement.width)
        lengthFormat = (measurement.length % 1 == 0) ? "%.0f" : "%.01f"
        let lengthToString = String(format: lengthFormat, measurement.length)
        
        var widthRange = "\(widthFromString)-\(widthToString)"
        if (widthFromString == widthToString)
        {
            widthRange = widthFromString
        }
        var lengthRange = "\(lengthFromString)-\(lengthToString)"
        if (lengthFromString == lengthToString)
        {
            lengthRange = lengthFromString
        }
        
        return "\(widthRange)cms wide and \(lengthRange)cms long"
    }
}

func ==(lhs:Measurement, rhs:Measurement) -> Bool
{
    return lhs.width == rhs.width && lhs.length == rhs.length
}