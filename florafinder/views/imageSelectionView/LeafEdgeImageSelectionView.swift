//
//  LeafEdgeImageSelectionView.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 6/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class LeafEdgeImageSelectionView: ImageSelectionView
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
        return 3
    }
    
    var selectedItem: LeafEdgeType?
    {
        return super._selectedItem?.tag as? LeafEdgeType
    }
    
    override internal var datasource: [ImageSelectionData]
    {
        if (_datasource.count == 0)
        {
            _datasource = [ImageSelectionData]()
            
            let service = ServiceFactory.shareInstance.leafEdgeTypeService
            
            for edge in service.getAll()
            {
                if let lookup = LeafEdgeTypeEnum(rawValue: edge.name!)
                {
                    if let image = lookup.image().changeColor(UIColor.leafDarkGreen())
                    {
                        let data = ImageSelectionData(image: image, text: edge.name, selected: false)
                        data.tag = edge
                        _datasource.append(data)
                    }
                }
            }
        }
        return _datasource
    }
}