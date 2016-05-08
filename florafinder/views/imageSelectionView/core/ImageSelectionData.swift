//
//  SelectableImageItem.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 4/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ImageSelectionData: NSObject
{
    var image: UIImage?
    var text: String?
    var selected: Bool?
    var tag: AnyObject?
    
    init(image: UIImage, text: String?, selected: Bool)
    {
        self.image = image
        self.text = text
        self.selected = selected
    }
    
    convenience init(image: UIImage)
    {
        self.init(image: image, text: nil, selected: false)
    }
}