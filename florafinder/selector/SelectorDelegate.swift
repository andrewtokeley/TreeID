//
//  File.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 19/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol SelectorDelegate
{
    func selector(selector: SelectorViewController, itemSelected:SelectorItem)
}