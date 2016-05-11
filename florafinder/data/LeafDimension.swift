//
//  LeafDimension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData


class LeafDimension: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    override var description: String
    {
        if (maximumSize != nil && minimumSize != nil)
        {            
            return "Leaves are \(minimumSize!.descriptionWithOtherMeasure(maximumSize!))."
        }
        return ""
    }
    
    var shape: LeafShapeEnum?
    {
        if (maximumSize == nil)
        {
            return LeafShapeEnum.Regular // guess
        }
        else if (maximumSize!.length < 1.5 && maximumSize!.width < 1)
        {
            return LeafShapeEnum.Small
        }
        else if (ratio > LeafShapeEnum.Narrow.ratio && maximumSize!.length > 5)
        {
            return LeafShapeEnum.Narrow
        }
        else if (ratio > LeafShapeEnum.Regular.ratio)
        {
            return LeafShapeEnum.Regular
        }
        else if (ratio > LeafShapeEnum.Broad.ratio && maximumSize!.width > 3)
        {
            return LeafShapeEnum.Broad
        }
        else
        {
            //propbably a leaf with no dimensions refined, but assume regular??
            return LeafShapeEnum.Regular
        }
    }
    
    var ratio: Float
    {
        if (widthMin != nil && lengthMin != nil && widthMax != nil && lengthMax != nil)
        {
            // average length divided by average width
            return (((lengthMin?.floatValue)! + (lengthMax?.floatValue)!)/2) / (((widthMin?.floatValue)! + (widthMax?.floatValue)!)/2)
        }
        
        return 0
    }
    
    var minimumSize: Measurement?
    {
        if (widthMin != nil && lengthMin != nil)
        {
            return Measurement(width: (widthMin?.floatValue)!, length: (lengthMin?.floatValue)!)
        }
        else
        {
            return nil
        }
    }
    
    var maximumSize: Measurement?
    {
        if (widthMax != nil && lengthMax != nil)
        {
            return Measurement(width: (widthMax?.floatValue)!, length: (lengthMax?.floatValue)!)
        }
        else
        {
            return nil
        }
    }
    
    
}
