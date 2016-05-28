//
//  ImageCollectionViewCell.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 2/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ImageCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var image: UIImageView!
    
    var rightAlign: Bool = false
    
    override func layoutSubviews()
    {
        if rightAlign
        {
            self.contentView.transform = CGAffineTransformMakeScale(-1, 1)
        }
    }
}