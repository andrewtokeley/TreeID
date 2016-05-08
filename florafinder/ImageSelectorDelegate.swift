//
//  ImageSelectorDelegate.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 23/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol ImageSelectorDelegate
{
    func imageSelector(imageSelector: ImageSelector, itemForIndex index: Int) -> ImageSelectorItem?
    func numberOfItemsInImageSelector(imageSelector: ImageSelector) -> Int
    func imageSelector(imageSelector: ImageSelector, didSelectIndex index: Int) -> Int
}
