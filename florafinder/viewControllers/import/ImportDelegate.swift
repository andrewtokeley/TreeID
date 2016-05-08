//
//  ImportDelegate.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 28/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol ImportDelegate {
    func importViewController(importViewController: ImportViewController, didImportRecords: Int)
}