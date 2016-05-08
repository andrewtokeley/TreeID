//
//  UIImageExtension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 1/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

extension UIImage
{
    func changeColor(color: UIColor) -> UIImage?
    {
            let size = self.size
            
            UIGraphicsBeginImageContextWithOptions(size, true, self.scale)
            UIColor.whiteColor().setFill()
            
            let rect = CGRectMake(0, 0, size.width, size.height)
            CGContextFillRect(UIGraphicsGetCurrentContext(), rect)
            self.drawInRect(rect)
            let compositedMaskImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            
            var unscaledSize = size
            unscaledSize.width *= self.scale;
            unscaledSize.height *= self.scale;
            
            UIGraphicsBeginImageContext(unscaledSize)
            let context = UIGraphicsGetCurrentContext()
            color.setFill()
            
            let unscaledRect = CGRectMake(0, 0, unscaledSize.width, unscaledSize.height)
            CGContextFillRect(context, unscaledRect)
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let compositedMaskImageRef = compositedMaskImage.CGImage
            let mask = CGImageMaskCreate(
                Int(unscaledSize.width),
                Int(unscaledSize.height),
                CGImageGetBitsPerComponent(compositedMaskImageRef),
                CGImageGetBitsPerPixel(compositedMaskImageRef),
                CGImageGetBytesPerRow(compositedMaskImageRef),
                CGImageGetDataProvider(compositedMaskImageRef),
                nil,
                false
            );
            
            let masked = CGImageCreateWithMask(colorImage.CGImage, mask)
            return UIImage(CGImage:masked!, scale:compositedMaskImage.scale, orientation:UIImageOrientation.Up)
    }

}