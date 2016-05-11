//
//  LeafShapeEnum.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 8/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

enum LeafShapeEnum: String
{
    case Narrow = "Narrow"
    case Broad = "Broad"
    case Regular = "Regular"
    case Small = "Small"
    
    static let allValues = [Regular, Broad, Narrow, Small]
    
    static func getByName(name: String) -> LeafShapeEnum?
    {
        return LeafShapeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
    }
    
    var displayName: String
    {
        switch self {
        case .Narrow: return "Long & Thin"
        case .Broad: return "Broad"
        case .Regular: return "Normal"
        case .Small: return "Small"
        }
    }

    var ratio: Float
    {
        switch self {
        case .Narrow: return 4.5
        case .Broad: return 0.1
        case .Regular: return 3.0
        default: return Float.NaN // not interested in the ratio of small leaved trees
        }
    }
    
    func order() -> Int
    {
        return LeafShapeEnum.allValues.indexOf(self)!
    }
    
    func image() -> UIImage
    {
        switch self {
        case .Narrow: return UIImage(named: "narrowleaf.png")!.changeColor(UIColor.leafDarkGreen())!
        case .Broad: return UIImage(named: "broadleaf.png")!.changeColor(UIColor.leafDarkGreen())!
        case .Regular: return UIImage(named: "smooth.png")!.changeColor(UIColor.leafDarkGreen())!
        case .Small: return UIImage(named: "cluster.png")!.changeColor(UIColor.leafDarkGreen())!
        }
    }
}