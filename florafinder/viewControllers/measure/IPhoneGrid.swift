//
//  IPhoneGrid.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class IPhoneGrid: UIView
{
    var rows: Int!
    var columns: Int!
    
    var color: UIColor = UIColor.lightGrayColor()
    {
        didSet
        {
            setBorderColor(color)
        }
    }
    
    private var phoneViewArray = [[UIView]]()
    
    private let PADDING = 1
    
    convenience init(frame: CGRect, rows: Int, columns: Int)
    {
        self.init(frame: frame)
        
        self.rows = rows
        self.columns = columns
        self.backgroundColor = UIColor.clearColor()
        
        self.initialisePhoneArray(rows, columns: columns)
    }
    
    override func layoutSubviews()
    {
        for row in 0...self.rows - 1
        {
            for column in 0...self.columns - 1
            {
                let phone = phoneView(row, column: column)
                
                let origin = CGPoint(x: phoneRectSize.width * (CGFloat(column)), y: phoneRectSize.height * (CGFloat(row)))
                phone.frame = CGRect(origin: origin, size: phoneRectSize)
                self.addSubview(phone)
            }
        }
    }
    /**
     Creat the UIViews for each of the phone images
     */
    private func initialisePhoneArray(rows: Int, columns: Int)
    {
        for _ in 0...self.rows - 1
        {
            var rowArray = [UIImageView]()
            
            for _ in 0...self.columns - 1
            {
                let imageView = UIImageView(image: UIImage(named: "iphone.png"))
                imageView.alpha = 0.1
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                rowArray.append(imageView)
            }
            self.phoneViewArray.append(rowArray)
        }
    }
    
    func setBorderColor(color: UIColor)
    {
//        for row in 0...self.rows - 1
//        {
//            for column in 0...self.columns - 1
//            {
//                phoneView(row,column: column).layer.borderColor = color.CGColor
//            }
//        }
    }
    
    func phoneView(row: Int, column: Int) -> UIView
    {
        let view = phoneViewArray[row][column]
        return view
    }
    
    var phoneRectSize: CGSize
    {
        var size = CGSizeZero
        
        let verticalDiff = abs(frame.size.width - Units.sizeOfPhoneInCentimetres.width)
        let horizontalDiff = abs(frame.size.height - Units.sizeOfPhoneInCentimetres.height)
        
        if (verticalDiff <= horizontalDiff)
        {
            // constrain grid height by frame height
            let phoneHeight = frame.size.height / CGFloat(rows)
            let phoneWidth = Units.sizeOfPhoneInCentimetres.width * phoneHeight / Units.sizeOfPhoneInCentimetres.height
            size.width = phoneWidth
            size.height = phoneHeight
        }
        else
        {
            // constrain grid width by frame width
            let phoneWidth = frame.size.width / CGFloat(columns)
            let phoneHeight = Units.sizeOfPhoneInCentimetres.height * phoneWidth / Units.sizeOfPhoneInCentimetres.width
            size.width = phoneWidth
            size.height = phoneHeight
        }
        
        return size
    }

}