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

class Flora: NSManagedObject, NYTPhoto {

    override var description: String
    {
        var sentences = [String]()
        
        if let text = notes { sentences.append(text) }
        if let text = leafUpper?.description { sentences.append(text) }
        
        return sentences.joinWithSeparator(" ")
    }
    
    //MARK: - NYTPhoto Protocol
    
    var placeholderImage: UIImage?
    {
        let service = ServiceFactory.shareInstance.imageService
        return service.placeholderImage
    }
    
    var attributedCaptionTitle: NSAttributedString?
    {
        return NSAttributedString(string: commonName ?? "")
    }
    
    var attributedCaptionSummary: NSAttributedString?
    {
        return NSAttributedString(string: commonName ?? "")
    }
    
    var attributedCaptionCredit: NSAttributedString?
    {
        return NSAttributedString(string: commonName ?? "")
    }
    
    var imageData: NSData?
    {
        return nil
    }
    
    var image: UIImage?
    {
        if let imagePath = self.imagePath
        {
            if let imageStored = ServiceFactory.shareInstance.imageService.getImage(imagePath)
            {
                return imageStored
            }
        }
        return nil
    }
}
