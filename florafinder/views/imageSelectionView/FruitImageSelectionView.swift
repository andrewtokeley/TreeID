//
//  FruitImageSelectionView.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class FruitImageSelectionView: ImageSelectionView
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
    
    var selectedItem: FruitColorType?
    {
        return super._selectedItem?.tag as? FruitColorType
    }
    
    override internal var datasource: [ImageSelectionData]
    {
        if (_datasource.count == 0)
        {
            _datasource = [ImageSelectionData]()
            
            let service = ServiceFactory.shareInstance.fruitColorTypeService
            
            for fruit in FruitColorTypeEnum.allValues
            {
                if let image = UIImage(named: "fruit.png")?.changeColor(fruit.color())
                {
                    let data = ImageSelectionData(image: image, text: fruit.rawValue, selected: false)
                    data.tag = service.getObject(fruit)
                    _datasource.append(data)
                }
                else
                {
                    
                }
            }
            
        }
        return _datasource
    }
    
}