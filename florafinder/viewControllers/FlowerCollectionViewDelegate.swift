//
//  File.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 4/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol CollectionViewFlowerDelegate {
    func collectionView(collectionView: UICollectionView, didSelectFlower flowerColor: FlowerColorType)
}

class FlowerCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var selectedFlowerColorType: FlowerColorType?
    var delegate: CollectionViewFlowerDelegate!
    var service: FlowerColorTypeProtocol!
    
    init(flowerService: FlowerColorTypeProtocol, delegate: CollectionViewFlowerDelegate)
    {
        self.service = flowerService
        self.delegate = delegate
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return FlowerColorTypeEnum.allValues.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        guard service != nil else { return }
        
        selectedFlowerColorType = service!.getObject(FlowerColorTypeEnum.allValues[indexPath.row])
        if let _ = selectedFlowerColorType
        {
            collectionView.reloadData()
            delegate?.collectionView(collectionView, didSelectFlower:selectedFlowerColorType!)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as! SearchResultCollectionViewCell
        
        let image = UIImage(named: "flower.png")?.changeColor(FlowerColorTypeEnum.allValues[indexPath.row].color())
        let text = FlowerColorTypeEnum.allValues[indexPath.row].rawValue
        let selected = selectedFlowerColorType?.name == text
        
        cell.image.image = image
        cell.selectionIcon.hidden = !selected
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 70)
    }
}