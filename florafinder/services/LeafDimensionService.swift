//
//  LeafDimensionService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class LeafDimensionService: Service<LeafDimension>, LeafDimensionProtocol {
    
    override init(controller: CoreDataController, entityName: NSString) {
        super.init(controller: controller, entityName: entityName)
    }
    
    func isComplete(dimension: LeafDimension) -> Bool
    {
        return dimension.widthMin != nil && dimension.widthMax != nil && dimension.lengthMin != nil && dimension.lengthMax != nil
    }
    
    func addLeafDimension(minimumSize: Measurement, maximumSize: Measurement) -> LeafDimension
    {
        let dimension = super.add()
        dimension.widthMin = minimumSize.width
        dimension.widthMax = maximumSize.width
        dimension.lengthMin = minimumSize.length
        dimension.lengthMax = maximumSize.length
        
        return dimension
    }
    
    func addLeafDimension(averageSize: Measurement) -> LeafDimension
    {
        return addLeafDimension(averageSize, maximumSize: averageSize)
    }

    func dimensionContainsSize(dimension: LeafDimension, size: Measurement) -> Bool
    {
        return dimensionContainsSize(dimension, size: size, tolerance: 0)
    }
    
    /**
      Returns how close the size is to the dimension range. For both the width and length dimensions a 0 means equal to the average of the min and max of that dimension. A 1 means one standard deviation from the mean. Therefore we expect 95% of leaf sample to be within 2 deviations from the mean.
     */
    func deviationOfSizeFromDimension(dimension: LeafDimension, size: Measurement) -> Measurement
    {
        if (dimension.widthMax == nil || dimension.widthMin == nil || dimension.lengthMax == nil || dimension.lengthMin == nil)
        {
            return Measurement(width:100, length: 100) // huge deviation
        }
        else
        {
            // Calculate the means from the min/max
            let widthAverage = (dimension.widthMax!.floatValue + dimension.widthMin!.floatValue) / 2
            let lengthAverage = (dimension.lengthMax!.floatValue + dimension.lengthMin!.floatValue) / 2
            
            // Standard deviation assuming min and max are 2 standard deviations from the mean
            var widthStdDev = (dimension.widthMax!.floatValue - widthAverage) / 2
            var lengthStdDev = (dimension.lengthMax!.floatValue - lengthAverage) / 2
            
            // if min and max values are the same, we shouldn't use a zero standard deviation, but instead give a 20% range
            if (widthStdDev == 0) { widthStdDev = widthAverage * 0.2 }
            if (lengthStdDev == 0) {lengthStdDev = lengthAverage * 0.2 }
            
            let widthDeviation = abs((size.width - widthAverage) / widthStdDev)
            let lengthDeviation = abs((size.length - lengthAverage) / lengthStdDev)
            
            // Return the combined variance as a measure to how close the size is to the dimension range. Zero means we're spot on the average.
            return Measurement(width: widthDeviation, length: lengthDeviation)
        }
    }
    
    func dimensionContainsSize(dimension: LeafDimension, size: Measurement, tolerance: Float) -> Bool
    {
        if !isComplete(dimension) {
            return false
        }
        let ok = (size.width >= dimension.widthMin!.floatValue * (1 - tolerance)) &&
                (size.width <= dimension.widthMax!.floatValue * (1 + tolerance)) &&
                (size.length >= dimension.lengthMin!.floatValue * (1 - tolerance)) &&
                (size.length <= dimension.lengthMax!.floatValue * (1 + tolerance))
        
        return ok
    }
    
}