//
//  UISliderExtension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 22/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

extension UISlider
{
    /**
     Move the thumb by the given number of points
    */
    func moveThumb(points: CGFloat)
    {
        let valueMovement = Float(points / self.frame.width) * (self.maximumValue - self.minimumValue)
        self.value = self.value + valueMovement
    }
    
//    func valueForXPosition(x: CGFloat, relativeTo: UIView) -> Float
//    {
//        let minX = thumbRect(relativeTo, atValue: self.minimumValue).midX
//        let maxX = thumbRect(relativeTo, atValue: self.maximumValue).midX
//        
//        // Find out what proportion x is along the slider
//        let proportion = (x - minX) / (maxX - minX)
//        
//        return self.minimumValue + Float(proportion) * (self.maximumValue - self.minimumValue)
//    }
    
    func thumbRect(relativeTo: UIView, atValue: Float) -> CGRect
    {
        let thumbRectRelative = self.thumbRectForBounds(self.bounds, trackRect: self.trackRectForBounds(self.bounds), value: atValue)
        let thumbRect = relativeTo.convertRect(thumbRectRelative, fromView: self)
        return thumbRect
    }
    
    func thumbRect(relativeTo: UIView) -> CGRect
    {
        return thumbRect(relativeTo, atValue: self.value)
    }
}