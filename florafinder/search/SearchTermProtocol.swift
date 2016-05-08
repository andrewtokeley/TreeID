//
//  File.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 28/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol SearchTermProtocol
{
    func execute(floraService: FloraServiceProtocol) -> [SearchResult]?
}