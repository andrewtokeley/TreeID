//
//  StringExtension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 3/02/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

extension String
{
    func numberOfMatches(searchText: String) -> Int
    {
        do
        {
            let regEx = try NSRegularExpression(pattern: searchText, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regEx.numberOfMatchesInString(self, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, self.characters.count))
                
                return matches
        }
        catch
        {
            return 0
        }
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat
    {
        var adjustedWidth = width
        adjustedWidth *= (25/(adjustedWidth+2)+1);
        
        let constraintRect = CGSize(width: adjustedWidth, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: [.UsesDeviceMetrics, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}