//
//  FloraDetailsViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 26/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import NYTPhotoViewer

class FloraDetailsViewController: UITableViewController, NYTPhotosViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var flora: Flora?
    var showAllDetails: Bool = false
    var photos: [NYTPhoto] = []
    
    //MARK: - Constants
    
    let NO_INFO = "-"
    let SEGUE_EDIT = "edit"
    let SEGUE_REFERENCE = "reference"
    
    let SECTION_HEADER = 0
    let ROW_DETAILS = 0
    
    let HEIGHT_DETAILS_LESS_LABEL: CGFloat = 70
    let MAX_HEIGHT_OF_DESCRIPTION_BEFORE_MORE_BUTTON: CGFloat = 118
    
    let SECTION_PHOTOS = 1
    let ROW_PHOTOS = 1
    
    let SECTION_REFERENCES = 2
    let ROW_REFERENCE_1 = 0
    
    //MARK: Outlets
    
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var photosView: UICollectionView!
    @IBOutlet weak var fullDescription: UILabel!
    @IBOutlet weak var externalReferenceURL: UIButton!
    @IBOutlet weak var iconsStackView: UIStackView!
    @IBOutlet weak var commonName: UILabel!
    @IBOutlet weak var latinName: UILabel!
    
    var leafDescriptions  = [String]()
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
         configureView()
    }
    
    override func viewWillLayoutSubviews() {
        
        // Required to ensure the correct size of the header tablecell
        super.viewWillLayoutSubviews()
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SEGUE_EDIT)
        {
            if let controller = segue.destinationViewController as? FloraViewController
            {
                if let flora = self.flora
                {
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                    controller.prepareForEdit(flora)
                }
            }
        }
        else if (segue.identifier == SEGUE_REFERENCE)
        {
            if let controller = segue.destinationViewController as? ReferenceViewController
            {
                if let flora = self.flora
                {
//                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                    controller.prepareForView(flora)
                }
            }
        }
        
    }

    //MARK: Functions
    
    func configureView()
    {
        // Temporary until we get multiple images
        photos.append(flora!)
        photos.append(flora!)
        
        photosView.backgroundColor = UIColor.whiteColor()
        
        externalReferenceURL.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        commonName.text = flora?.commonName
        fullDescription.text = flora?.description
        fullDescription.sizeToFit()
        latinName.text = "Dacrydium cupressinum"
        
        setIcons()
        
        if let reference = flora?.externalURL
        {
            externalReferenceURL.setAttributedTitle(NSAttributedString(string: reference), forState: UIControlState.Normal)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func prepareForView(flora: Flora)
    {
        self.flora = flora
        self.title = flora.commonName
    }
    
    func setIcons()
    {
        var images = [UIImage]()
        
        if let flowerColor = flora?.flowerColor?.color as? UIColor
        {
            let image = UIImage(named: "flower.png")
            images.append(image!.changeColor(flowerColor)!)
        }
        
        if let fruitColor = flora?.fruitColor?.color as? UIColor
        {
            let image = UIImage(named: "fruit.png")
            images.append(image!.changeColor(fruitColor)!)
        }
        
        if let edge = flora?.leafUpper?.edgeType
        {
            let type = LeafEdgeTypeEnum(rawValue: edge.name!)
            images.append(type!.image())
        }
        
        if let formation = flora?.leafUpper?.formationType
        {
            let type = LeafFormationTypeEnum(rawValue: formation.name!)
            images.append(type!.image())
        }
        
        let count = images.count
        let numberOfIcons = 3
        
        for i in 0...numberOfIcons
        {
            if (i < count)
            {
                (iconsStackView.subviews[numberOfIcons - i] as! UIImageView).image = images[i]
            }
            else
            {
                (iconsStackView.subviews[numberOfIcons - i] as! UIImageView).image = nil
            }
        }
        
    }
    
    func previewImage(photo: NYTPhoto)
    {
        let controller = NYTPhotosViewController(photos: self.photos, initialPhoto: photo)
        controller.delegate = self
        self.presentViewController(controller, animated: false, completion: nil)
    }
    
    //MARK: TableView
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let PADDING: CGFloat = 8
        
        // For all rows in the Leaves section, apart from the header row
        if (indexPath.section == SECTION_HEADER && indexPath.row == ROW_DETAILS)
        {
            return fullDescription.frame.height + HEIGHT_DETAILS_LESS_LABEL + PADDING
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == SECTION_REFERENCES && flora?.externalURL == nil)
        {
            return 0
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    //MARK - NYTPhotosViewControllerDelegate

    func photosViewController(photosViewController: NYTPhotosViewController, handleActionButtonTappedForPhoto photo: NYTPhoto) -> Bool {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            guard let photoImage = photo.image else { return false }
            
            let shareActivityViewController = UIActivityViewController(activityItems: [photoImage], applicationActivities: nil)
            
            shareActivityViewController.completionWithItemsHandler = {(activityType: String?, completed: Bool, items: [AnyObject]?, error: NSError?) in
                if completed {
                    photosViewController.delegate?.photosViewController!(photosViewController, actionCompletedWithActivityType: activityType!)
                }
            }
            
            shareActivityViewController.popoverPresentationController?.barButtonItem = photosViewController.rightBarButtonItem
            photosViewController.presentViewController(shareActivityViewController, animated: true, completion: nil)
            
            return true
        }
        
        return false
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController, captionViewForPhoto photo: NYTPhoto) -> UIView?
    {
        let label = UILabel()
        label.text = photo.attributedCaptionTitle?.string
        label.textColor = UIColor.whiteColor()
        return label
    }
    
    //MARK: Actions
    
    @IBAction func moreDetails(sender: AnyObject) {
        showAllDetails = !showAllDetails
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //MARK: Photo CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0)
        {
            return photos.count
        }
        else
        {
            return 0
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        previewImage(self.photos[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as! ImageCollectionViewCell

        cell.image.image = photos[indexPath.row].image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 10, bottom: 0, right: 10)
    }
    
}