//
//  SearchTerm.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 23/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchTerm
{
    var description: String
    {
        return ""
    }
    
    var strict: Bool = false
    
    func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
    {
        return nil
    }
}