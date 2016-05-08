//
//  File.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 4/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol CollectionViewFruitDelegate {
    func collectionView(collectionView: UICollectionView, didSelectFruit fruitColor: FruitColorType)
}

class FruitCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource
{
    var selectedFruitColorType: FruitColorType?
    var delegate: CollectionViewFruitDelegate!
    var service: FruitColorTypeProtocol!
    
    init(fruitService: FruitColorTypeProtocol, delegate: CollectionViewFruitDelegate)
    {
        self.service = fruitService
        self.delegate = delegate
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return FruitColorTypeEnum.allValues.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        guard service != nil else { return }
        
        selectedFruitColorType = service!.getObject(FruitColorTypeEnum.allValues[indexPath.row])
        if let _ = selectedFruitColorType
        {
            collectionView.reloadData()
            delegate?.collectionView(collectionView, didSelectFruit:selectedFruitColorType!)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as! ImageSelectionViewCell
        
        let image = UIImage(named: "fruit.png")?.changeColor(FruitColorTypeEnum.allValues[indexPath.row].color())
        
        //let selected = selectedFruitColorType?.name == text
        cell.label.text = FruitColorTypeEnum.allValues[indexPath.row].rawValue
        cell.imageView.image = image
        //cell.selectionIcon.hidden = !selected
        
        return cell
    }
    
}