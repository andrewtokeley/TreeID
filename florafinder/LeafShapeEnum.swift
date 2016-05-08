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
    
    static let allValues = [Regular, Broad, Narrow]
    
    static func getByName(name: String) -> LeafShapeEnum?
    {
        return LeafShapeEnum.allValues.filter( { $0.rawValue.lowercaseString == name.lowercaseString } ).first
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
        case .Regular: return UIImage(named: "indiviual.png")!.changeColor(UIColor.leafDarkGreen())!
        }
    }
}