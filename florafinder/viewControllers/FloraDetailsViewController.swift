//
//  FloraDetailsViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 26/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import NYTPhotoViewer

//class specialButton: UIButton, NYTPhotoCaptionViewLayoutWidthHinting
//{
//    var preferredMaxLayoutWidth: CGFloat
//    {
//        set{}
//        get{return 100}
//    }
//}

class FloraDetailsViewController: UITableViewController, NYTPhotosViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate
{
    
    let SESSION_KEY_PREFIX = "FloraDetailsImageRecords_"
    
    var flora: Flora?
    var showAllDetails: Bool = false
    var photos: [NYTPhoto] = []
    var layoutGigDone: Bool = false
    
    //MARK: - Constants
    let COLLECTIONVIEW_ICONS = 0
    let COLLECTIONVIEW_PHOTOS = 1
    
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
    
    @IBOutlet weak var iconsCollectionView: UICollectionView!
    //@IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var photosView: UICollectionView!
    @IBOutlet weak var fullDescription: UILabel!
    @IBOutlet weak var externalReferenceURL: UIButton!
    @IBOutlet weak var commonName: UILabel!
    @IBOutlet weak var latinName: UILabel!
    
    @IBOutlet weak var moreButtonItem: UIBarButtonItem!
    var leafDescriptions  = [String]()
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
         configureView()
    }
    
    override func viewWillLayoutSubviews() {
        
        // Required to ensure the correct size of the header tablecell. When relying on the tableView:heightForRowAtIndexPath it doesn't have the correct label height until this method is called.
        if (!layoutGigDone)
        {
            //super.viewWillLayoutSubviews()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            layoutGigDone = true
        }
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
                    controller.prepareForView(flora)
                }
            }
        }
        
    }

    //MARK: Functions
    
    func configureView()
    {
        let session = ServiceFactory.shareInstance.sessionStateService
        
        if let imageRoot = flora?.imagePath
        {
            
            // Check cache first
            let sessionKey = SESSION_KEY_PREFIX + imageRoot
            if let imageRecords = session.state[sessionKey] as? [ImageRecord]
            {
                self.photos = imageRecords
                self.photosView.reloadData()
            }
            else
            {
                let service = ServiceFactory.shareInstance.imageService
                var imageRecords = [ImageRecord]()
                service.getImageRecords(imageRoot, recordFound: { (imageRecord) in
                    
                    imageRecords.append(imageRecord)
                    session.state[sessionKey] = imageRecords
                    self.photos.append(imageRecord)
                    self.photosView.reloadData()
                })
            }
        }
        
        iconsCollectionView.backgroundColor = UIColor.whiteColor()
        photosView.backgroundColor = UIColor.whiteColor()
        
        externalReferenceURL.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        commonName.text = flora?.commonName
        fullDescription.text = flora?.description
        fullDescription.sizeToFit()
        
        latinName.text = flora?.scientificName ?? "-"
        
        if let reference = flora?.externalURL
        {
            externalReferenceURL.setAttributedTitle(NSAttributedString(string: reference), forState: UIControlState.Normal)
        }
        
        iconsCollectionView.transform = CGAffineTransformMakeScale(-1, 1)
    }
    
    func prepareForView(flora: Flora)
    {
        self.flora = flora
        self.title = ""
    }
    
    lazy var iconImages: [UIImage] =
    {
        var images = [UIImage]()
        
        if let flowerColor = self.flora?.flowerColor?.color as? UIColor
        {
            if let image = UIImage(named: "flower.png")
            {
                images.append(image.changeColor(flowerColor)!)
            }
        }
        
        if let fruitColor = self.flora?.fruitColor?.color as? UIColor
        {
            if let image = UIImage(named: "fruit.png")
            {
                images.append(image.changeColor(fruitColor)!)
            }
        }
        
        if let edge = self.flora?.leafUpper?.edgeType
        {
            if let type = LeafEdgeTypeEnum(rawValue: edge.name!)
            {
                images.append(type.image())
            }
        }
        
        if let formation = self.flora?.leafUpper?.formationType
        {
            if let type = LeafFormationTypeEnum(rawValue: formation.name!)
            {
                images.append(type.image())
            }
        }
        return images
    }()
    
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
    
    //MARK: - NYTPhotosViewControllerDelegate

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
    
//    func photosViewController(photosViewController: NYTPhotosViewController, captionViewForPhoto photo: NYTPhoto) -> UIView?
//    {
//        return nil
//    }
    
//    func deletePhoto(sender: UILabel)
//    {
//        photos.removeAtIndex(sender.tag)
//    }
    
    //MARK: Actions
    @IBAction func moreButton(sender: UIBarButtonItem) {
        let action = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Found it!" , "Map")
        action.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
    }
    
    //MARK: Photo CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = photos.count
        if (collectionView.tag == COLLECTIONVIEW_ICONS)
        {
            count = iconImages.count
        }
        return count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if collectionView.tag == COLLECTIONVIEW_PHOTOS
        {
            previewImage(self.photos[indexPath.row])
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as! ImageCollectionViewCell

        if collectionView.tag == COLLECTIONVIEW_PHOTOS
        {
            cell.image.image = photos[indexPath.row].image
        }
        else if collectionView.tag == COLLECTIONVIEW_ICONS
        {
            cell.rightAlign = true
            cell.image.image = iconImages[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size = CGSize(width: 100, height: 100)
        if collectionView.tag == COLLECTIONVIEW_ICONS
        {
            size = CGSize(width: 20, height: 20)
        }
        return size
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        var insets = UIEdgeInsets(top: 2, left: 10, bottom: 0, right: 10)
        if collectionView.tag == COLLECTIONVIEW_ICONS
        {
            insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return insets
    }
    
}