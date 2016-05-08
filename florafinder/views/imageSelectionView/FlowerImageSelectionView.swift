//
//  FlowerImageSelectionView.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class FlowerImageSelectionView: ImageSelectionView
{
    override internal var cellSize: CGSize
    {
        return CGSizeMake(40,50)
    }
    
    override internal var showLabel: Bool
    {
        return false
    }
    
    override internal var numberOfColumns: Int?
    {
        return 5
    }
    
    var selectedItem: FlowerColorType?
    {
        return super._selectedItem?.tag as? FlowerColorType
    }
    
    override internal var datasource: [ImageSelectionData]
    {
        if (_datasource.count == 0)
        {
            _datasource = [ImageSelectionData]()
            
            let service = ServiceFactory.shareInstance.flowerColorTypeService
            
            for flower in FlowerColorTypeEnum.allValues
            {
                if let image = UIImage(named: "flower.png")?.changeColor(flower.color())
                {
                    let data = ImageSelectionData(image: image, text: flower.rawValue, selected: false)
                    data.tag = service.getObject(flower)
                    _datasource.append(data)
                }
            }
        }
        return _datasource
    }
}