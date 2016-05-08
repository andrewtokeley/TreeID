//
//  Grid.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 30/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class Grid: UIView
{
    var gridSizeInCM: CGFloat?
    
    convenience init(frame: CGRect, gridSizeInCM: CGFloat)
    {
        self.init(frame: frame)
        
        self.gridSizeInCM = gridSizeInCM
        self.backgroundColor = UIColor.clearColor()
    }
 
    override func drawRect(rect: CGRect) {
        
        guard gridSizeInCM != nil else {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, UIColor.leafLightGreen().CGColor)

        // Add rows
        
        // Start at top left of frame
        
        var y:CGFloat = frame.size.height
        while y >= 0
        {
            CGContextMoveToPoint(context, 0, y)
            CGContextAddLineToPoint(context, frame.size.width, y)
            
            y -= Units.centimetresToPoints(gridSizeInCM!)
        }
        
        var x:CGFloat = 0
        while x <= frame.size.width
        {
            CGContextMoveToPoint(context, x, 0)
            CGContextAddLineToPoint(context, x, frame.size.height)
            
            x += Units.centimetresToPoints(gridSizeInCM!)
        }
        CGContextStrokePath(context);
    }
    
}