//
//  MeasureLeafDelegate.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 30/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol MeasureLeafDelegate
{
    func measureCompleted(width: CGFloat, length: CGFloat)
    func measureNotDefined()
}