//
//  LeafFormationType.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 18/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData


class LeafFormationType: NSManagedObject {

    override var description: String
    {
        var result: String = ""
        
        if (name != nil)
        {
            if let enumerator = LeafFormationTypeEnum(rawValue: name!)
            {
                switch enumerator
                {
                case LeafFormationTypeEnum.Paired:
                        result = "Leaves form in pairs, opposite from one another."
                case LeafFormationTypeEnum.Alternate:
                        result = "Leaves are individually attached."
                case LeafFormationTypeEnum.Star:
                        result = "Leaves form together in a star like formation. A common example is the Five Finger."
                case LeafFormationTypeEnum.Cluster:
                        result = "Leafs are small, typically less than centimetre long and a few milimetres wide. They are clustred together, often in two rows. Common examples include Rimu, Kowhai and Miro."
                }
            }
        }
        return result
    }


}
