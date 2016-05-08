//
//  LeafDimensionProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol LeafDimensionProtocol {
    
    func addLeafDimension(minimumSize: Measurement, maximumSize: Measurement) -> LeafDimension
    func addLeafDimension(averageSize: Measurement) -> LeafDimension
    
    func isComplete(dimension: LeafDimension) -> Bool
    
    func deviationOfSizeFromDimension(dimension: LeafDimension, size: Measurement) -> Measurement
    
    func dimensionContainsSize(dimension: LeafDimension, size: Measurement) -> Bool
    func dimensionContainsSize(dimension: LeafDimension, size: Measurement, tolerance: Float) -> Bool
}