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
    var imageCache: UIImage?
    var metaData: ImageMetaData?
    var imageFetcher: (() -> UIImage)?
    
    override init()
    {
        super.init()
    }
    
    convenience init(imageFetcher: () -> UIImage)
    {
        self.init()
        self.imageFetcher = imageFetcher
    }
    
    convenience init(image: UIImage, metaData: NSData?)
    {
        self.init()
        self.image = image
        if (metaData != nil)
        {
            self.metaData = ImageMetaData(metaData: metaData!)
        }
    }
    
    convenience init(image: UIImage)
    {
        self.init(image: image, metaData: nil)
    }
    
    convenience init(imageURL: NSURL)
    {
        self.init()
        self.imageURL = imageURL
    }
    
    //MARK: - NYTPhoto properties
    var imageURL: NSURL?
    var image: UIImage?
    var imageData: NSData?
    
    var attributedCaptionTitle: NSAttributedString?
    {
        if let title = metaData?.title
        {
            return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)])
        }
        return nil
    }

    var attributedCaptionSummary: NSAttributedString?
    {
        if let summary = metaData?.summary
        {
            return NSAttributedString(string: summary, attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)])
        }
        return nil
    }
    
    var attributedCaptionCredit: NSAttributedString?
    {
        if let credit = metaData?.credit
        {
            return NSAttributedString(string: credit, attributes:[NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)])
        }
        return nil
    }

    // MARK: - Other properties
    var placeholderImage: UIImage?
    {
        let service = ServiceFactory.shareInstance.imageService
        return service.placeholderImage
    }

    }