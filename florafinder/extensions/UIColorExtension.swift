//
//  UIColorExtension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/02/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

extension UIColor
{
    public class func defaultTableCellSeparator() -> UIColor
    {
        return UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
    }
    
    //MARK: - Leaves
    
    public class func leafVeryDarkGreen() -> UIColor
    {
        return UIColor(red: 3/255, green: 44/255, blue: 11/255, alpha: 1)
    }
    public class func leafDarkGreen() -> UIColor
    {
        return UIColor(red: 57/255, green: 99/255, blue: 5/255, alpha: 1)
    }
    public class func leafGreen() -> UIColor
    {
        return UIColor(red: 79/255, green: 143/255, blue: 0, alpha: 1)
    }
    public class func leafLightGreen() -> UIColor
    {
        return UIColor(red: 160/255, green: 191/255, blue: 121/255, alpha: 1)
    }
    
    //MARK: - Flowers
    public class func flowerYellow() -> UIColor
    {
        return UIColor(red: 255/255, green: 217/255, blue: 102/255, alpha: 1)
    }
    public class func flowerWhite() -> UIColor
    {
        return UIColor(red: 246/255, green: 234/255, blue: 214/255, alpha: 1)
    }
    public class func flowerRed() -> UIColor
    {
        return UIColor(red: 214/255, green: 28/255, blue: 14/255, alpha: 1)
    }
    public class func flowerPink() -> UIColor
    {
        return UIColor(red: 254/255, green: 106/255, blue: 164/255, alpha: 1)
    }
    
    //MARK: - Fruit
    public class func fruitPink() -> UIColor
    {
        return UIColor(red: 254/255, green: 106/255, blue: 164/255, alpha: 1)
    }
    public class func fruitOrange() -> UIColor
    {
        return UIColor(red: 255/255, green: 171/255, blue: 64/255, alpha: 1)
    }
    public class func fruitYellow() -> UIColor
    {
        return UIColor(red: 255/255, green: 217/255, blue: 102/255, alpha: 1)
    }
    public class func fruitGreen() -> UIColor
    {
        return UIColor(red: 176/255, green: 209/255, blue: 163/255, alpha: 1)
    }
    public class func fruitRed() -> UIColor
    {
        return UIColor(red: 214/255, green: 28/255, blue: 14/255, alpha: 1)
    }
    public class func fruitDarkRed() -> UIColor
    {
        return UIColor(red: 158/255, green: 21/255, blue: 19/255, alpha: 1)
    }

    public class func fruitLightBlue() -> UIColor
    {
        return UIColor(red: 89/255, green: 183/255, blue: 213/255, alpha: 1)
    }

    public class func fruitPurple() -> UIColor
    {
        return UIColor(red: 114/255, green: 17/255, blue: 127/255, alpha: 1)
    }
}
