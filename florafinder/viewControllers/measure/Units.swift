//
//  Units.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class Units
{
    enum PhoneModels: Int
    {
        case iPhone5
        case iPhone6
        case iPhone6Plus
    }
    
    static let POINTS_PER_MM:CGFloat = 6.409
    static let POINTS_PER_INCH: CGFloat = 78.94
    
    static func pointsToCentimetre(points: CGFloat) -> CGFloat
    {
        return pointsToMillimetres(points)/10
    }
    
    static func pointsToCentimetre(points: Int) -> CGFloat
    {
        return pointsToMillimetres(points)/10
    }
    
    static func pointsToMillimetres(points: CGFloat) -> CGFloat
    {
        return CGFloat(points)/POINTS_PER_MM
    }
    
    static func pointsToMillimetres(points: Int) -> CGFloat
    {
        return CGFloat(points)/POINTS_PER_MM
    }
    
    static func pointsToInches(points: CGFloat) -> CGFloat
    {
        return CGFloat(points)/POINTS_PER_INCH
    }
    
    static func pointsToInches(points: Int) -> CGFloat
    {
        return CGFloat(points)/POINTS_PER_INCH
    }
    
    static func centimetresToPoints(centimetres: CGFloat) -> CGFloat
    {
        return centimetres * 10 * POINTS_PER_MM
    }
    
    static var sizeOfPhoneInCentimetres: CGSize
    {
        // TODO: change depending on phone
        // iPhone6
        return CGSize(width: 6.71, height: 13.81)
    }
}