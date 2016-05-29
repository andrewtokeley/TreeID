//
//  ImageMetaData.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 29/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ImageMetaData
{
    /* example of meta data
     "imageTitle": "Akeake leaves",
     "imageSummary": "Andrew Tokeley",
     "imageCredit": "http://remote.bloxus.com/"
     */
    
    let JSON_TITLE = "imageTitle"
    let JSON_SUMMARY = "imageSummary"
    let JSON_CREDIT = "imageCredit"

    var metaData: NSData
    
    init(metaData: NSData)
    {
        self.metaData = metaData
    }
    
    //MARK: - Meta data
    
    lazy var json: AnyObject? =
    {
        return try? NSJSONSerialization.JSONObjectWithData(self.metaData, options: NSJSONReadingOptions.AllowFragments)
    }()
    
    var title: String?
    {
        return json?[JSON_TITLE] as? String
    }
    
    var summary: String?
    {
        return json?[JSON_SUMMARY] as? String
    }
    
    var credit: String?
    {
        return json?[JSON_CREDIT] as? String
    }
}
