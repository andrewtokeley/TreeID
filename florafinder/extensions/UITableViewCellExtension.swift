//
//  UITableViewCellExtension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 13/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

extension UITableViewCell
{
    func separatorLeftMargin(margin: CGFloat)
    {
        self.layoutMargins = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
        self.separatorInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: 0)
    }
}