//
//  ImageRecord.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 12/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import NYTPhotoViewer

enum ImageRecordExceptions: ErrorType
{
    case InvalidMetaData(reason: String)
}

class ImageRecord: NSObject, NYTPhoto
{
    /* example of meta data
    "imageTitle": "Akeake leaves",
    "imageSummary": "Andrew Tokeley",
    "imageCredit": "http://remote.bloxus.com/"
     */
    
    let JSON_TITLE = "imageTitle"
    let JSON_SUMMARY = "imageSummary"
    let JSON_CREDIT = "imageCredit"
    
    var imageCache: UIImage?
    
    init(image: UIImage, metaData: NSData?)
    {
        super.init()
        
        self.image = image
        if metaData != nil
        {
            // going to ignore errors for now
            parseMetaData(metaData!)
        }
    }
    
    convenience init(image: UIImage)
    {
        self.init(image: image, metaData: nil)
    }
    
    //MARK: - NYTPhoto properties
    var image: UIImage?
    var imageData: NSData?
    var attributedCaptionTitle: NSAttributedString?
    var attributedCaptionSummary: NSAttributedString?
    var attributedCaptionCredit: NSAttributedString?
    
    // MARK: - Other properties
    var placeholderImage: UIImage?
    {
        let service = ServiceFactory.shareInstance.imageService
        return service.placeholderImage
    }

    //MARK: - Meta data
    func parseMetaData(metaData: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(metaData, options: NSJSONReadingOptions.AllowFragments)
            
            if let title = json[JSON_TITLE] as? String
            {
                //self.attributedCaptionTitle = NSAttributedString(string: title)
                
                self.attributedCaptionTitle = NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)])
            }
            if let summary = json[JSON_SUMMARY] as? String
            {
                self.attributedCaptionSummary = NSAttributedString(string: summary, attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)])
            }
            if let credit = json[JSON_CREDIT] as? String
            {
                self.attributedCaptionCredit = NSAttributedString(string: credit, attributes:[NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)])
            }
        }
        catch
        {
            return false
        }
        return true
    }
}