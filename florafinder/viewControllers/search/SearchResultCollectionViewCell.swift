//
//  SearchResultCellViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchResultCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var selectionIcon: UIView!
    
    override func layoutSubviews() {
        selectionIcon?.layer.cornerRadius = 4
        selectionIcon?.backgroundColor = UIColor.leafDarkGreen()
    }
}