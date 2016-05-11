//
//  ImageSelectionView.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 4/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ImageSelectionView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{

    //MARK: - Private properties
    
    private let CELL_IDENTIFIER = "cell"
    internal var _datasource = [ImageSelectionData]()
    
    //MARK: - Initialisers
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.addSubview(collectionView)
    }
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: Public properties
    var delegate: ImageSelectionViewDelegate?
    
    /**
     Returns the size of all the content - not just what's visible
    */
    var contentSize: CGSize
    {
        // adding 10 to height to cater for section
        return CGSizeMake(collectionView.contentSize.width, collectionView.contentSize.height + 10)
    }
    
    //MARK: - Override-able methods
    
    internal var datasource: [ImageSelectionData]
    {
        if (_datasource.count == 0)
        {
            let testData = ImageSelectionData(image: UIImage(named: "fruit.png")!)
            testData.text = "Item"
            _datasource.append(testData)
        }
        return _datasource
    }
    
    internal var cellSize: CGSize
    {
        return CGSize(width: 40  , height: 70)
    }
    
    internal var showLabel: Bool
    {
        return true
    }
    
    internal var numberOfColumns: Int?
    {
        // Nil means there are no restictions on the number of columns
        return nil
    }
    
    internal var _selectedItem: ImageSelectionData?
    
    //MARK: - Helpers
    
    func clearSelection()
    {
        _selectedItem = nil
        
        // hide the selectionStrip (can do better than getting the whole collectinview to reload. e.g. keep track of the selectedStrip which is visible and hide it directly)
        collectionView.reloadData()
    }
    
    //MARK: - SubViews
    
    lazy var collectionView: UICollectionView =
        {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = self.cellSize
            
            let view = UICollectionView(frame: self.frame, collectionViewLayout: layout)
            view.delegate = self
            view.dataSource = self
            view.scrollEnabled = false
            view.backgroundColor = UIColor.clearColor()
            view.registerClass(ImageSelectionViewCell.self, forCellWithReuseIdentifier: self.CELL_IDENTIFIER)
            return view
    }()
    
    //MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        if let columns = numberOfColumns
        {
            // Used to make sure rounding doesn't make the required space between cells too big
            let ROUNDING_NUDGE: CGFloat = 1
            let viewWidth = self.frame.size.width
            let cellWidth = cellSize.width
            
            let spaceBetweenCellsRequired = viewWidth/CGFloat(columns) - cellWidth - ROUNDING_NUDGE
            
            if spaceBetweenCellsRequired > 0
            {
                return spaceBetweenCellsRequired
            }
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return datasource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.CELL_IDENTIFIER, forIndexPath:indexPath) as! ImageSelectionViewCell
        
        cell.imageView.image = datasource[indexPath.row].image
        
        cell.showLabel = showLabel
        
        if (showLabel)
        {
            cell.label.text = datasource[indexPath.row].text
        }
        
        cell.selectionStrip.hidden = datasource[indexPath.row] != _selectedItem
        
        self.needsUpdateConstraints()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // If you're selecting the selected item, deselect it
        if (_selectedItem == datasource[indexPath.row])
        {
            _selectedItem = nil
        }
        else
        {
            _selectedItem = datasource[indexPath.row]
        }
        
        collectionView.reloadData()
        delegate?.imageSelectionView(self, didSelectItem: _selectedItem)
    }
}