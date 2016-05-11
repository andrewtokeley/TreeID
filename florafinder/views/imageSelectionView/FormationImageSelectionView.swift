//
//  FormationImageSelectionView.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class FormationImageSelectionView: ImageSelectionView
{
    override internal var cellSize: CGSize
    {
        return CGSizeMake(75,80)
    }
    
    var selectedItem: LeafFormationType?
    {
        return super._selectedItem?.tag as? LeafFormationType
    }
    
    override internal var numberOfColumns: Int?
    {
        return 3
    }
    
    override internal var datasource: [ImageSelectionData]
    {
        if (_datasource.count == 0)
        {
            _datasource = [ImageSelectionData]()
            
            let service = ServiceFactory.shareInstance.leafFormationTypeService
            
            for formation in service.getAll()
            {
                if let lookup = LeafFormationTypeEnum(rawValue: formation.name!)
                {
                    if let image = lookup.image().changeColor(UIColor.leafDarkGreen())
                    {
                        let data = ImageSelectionData(image: image, text: formation.name, selected: false)
                        data.tag = formation
                        _datasource.append(data)
                    }
                }
            }
        }
        return _datasource
    }

}