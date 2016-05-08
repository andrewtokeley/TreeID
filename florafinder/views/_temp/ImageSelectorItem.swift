//
//  ImageSelectorItem.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ImageSelectorItem
{
    var image: UIImage?
    var caption: String?
    var isSelected: Bool = false

    init(image: UIImage, caption: String, isSelected: Bool)
    {
        self.image = image
        self.caption = caption
        self.isSelected = isSelected
    }

    convenience init(image: UIImage, caption: String)
    {
        self.init(image: image, caption: caption, isSelected: false)
    }
    
}