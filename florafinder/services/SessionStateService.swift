//
//  SessionStateService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 18/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SessionStateService
{
    static var shareInstance: SessionStateService =
    {
            return SessionStateService()
    }()
   
    var savedSearchState: SearchState
    {
        var state = SearchState()
        state.selectedLeafShape = LeafShapeEnum.Broad
        
        return state
    }
}