//
//  SelectorItem.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 19/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SelectorItem {
    
    var title: String
    var subTitle: String?
    var object: AnyObject?
    var view: UIView?
    
    init(title: String, subTitle: String?, object: AnyObject?)
    {
        self.title = title
        self.subTitle = subTitle
        self.object = object        
    }
}