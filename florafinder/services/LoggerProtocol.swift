//
//  LoggerProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 4/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol LoggerProtocol
{
    func log(message: String)
    func log(exception: exception)
}