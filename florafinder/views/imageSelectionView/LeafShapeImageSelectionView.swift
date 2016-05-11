//
//  File.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 9/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class LeafShapeImageSelectionView: ImageSelectionView
{
    override internal var cellSize: CGSize
    {
        return CGSizeMake(70,80)
    }
    
    override internal var showLabel: Bool
    {
        return true
    }
    
    override internal var numberOfColumns: Int?
    {
        return 4
    }
    
    var selectedItem: LeafShapeEnum?
    {
        if let rawValue = super._selectedItem?.tag as? String
        {
            return LeafShapeEnum(rawValue: rawValue)
        }
        return nil
    }
    
    override internal var datasource: [ImageSelectionData]
    {
        if (_datasource.count == 0)
        {
            _datasource = [ImageSelectionData]()
            
            for shape in LeafShapeEnum.allValues
            {
                if let image = shape.image().changeColor(UIColor.leafDarkGreen())
                {
                    let data = ImageSelectionData(image: image, text: shape.displayName, selected: false)
                    data.tag = shape.rawValue
                    _datasource.append(data)
                }
            
            }
        }
        return _datasource
    }
    
}