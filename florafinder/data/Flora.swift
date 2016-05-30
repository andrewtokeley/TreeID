//
//  Flora.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 13/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import CoreData
import NYTPhotoViewer

class Flora: NSManagedObject //, NYTPhoto 
{

    //var imageRecordCache: ImageRecord?
    
    override var description: String
    {
        var sentences = [String]()
        
        if let text = notes {
            sentences.append(text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) + "\n\n")
        }
        if let text = leafUpper?.description { sentences.append(text) }
        
        return sentences.joinWithSeparator("")
    }
    
    //MARK: - NYTPhoto Protocol
    
//    var placeholderImage: UIImage?
//    {
//        let service = ServiceFactory.shareInstance.imageService
//        return service.placeholderImage
//    }
//    
//    var attributedCaptionTitle: NSAttributedString?
//    {
//        return imageRecord?.attributedCaptionTitle
//    }
//    
//    var attributedCaptionSummary: NSAttributedString?
//    {
//        return imageRecord?.attributedCaptionSummary
//    }
//    
//    var attributedCaptionCredit: NSAttributedString?
//    {
//        return imageRecord?.attributedCaptionCredit
//    }
//    
//    var imageData: NSData?
//    {
//        return nil
//    }
//    var image: UIImage?
//    {
//        return imageRecord?.image
//    }
    var thumbnailName: String?
    {
        if let imageRoot = self.imagePath
        {
            // TODO - this assujmes jpg files sucks, but is temporary.
            return imageRoot + "_main.jpg"
        }
        return nil
    }
//
//    var imageRecord: ImageRecord?
//    {
//        if (imageRecordCache == nil)
//        {
//            if let imageName = thumbnailName
//            {
//                if let imageRecord = ServiceFactory.shareInstance.imageService.getImageRecords(imageName).first
//                {
//                    imageRecordCache = imageRecord
//                }
//            }
//        }
//        return imageRecordCache
//    }
}
