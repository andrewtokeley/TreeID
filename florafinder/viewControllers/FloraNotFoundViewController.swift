//
//  FloraNotFoundViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import MobileCoreServices
import NYTPhotoViewer
import MessageUI

class FloraNotFoundViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NYTPhotosViewControllerDelegate, MFMailComposeViewControllerDelegate
{
    let SECTION_PHOTO_PERMISSION = 2
    let ROW_PERMISSION = 0

    let ACTION_CAPTURE_TAG = 0
    let ACTION_TAKE = 1
    let ACTION_SELECT = 2
    
    let ACTION_PHOTO_TAG = 1
    let ACTION_VIEW = 1
    let ACTION_DELETE = 2
    
    let MESSAGE_OPENING = "I searched for these properties and didn't find what I was looking for :-("
    
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!

    var photosViewController: NYTPhotosViewController?
    var attachedPhotos = [UIImage]()
    var selectedPhotoIndex: Int?
    
    override func viewDidLoad()
    {
        self.title = "Report"
        message.text = messageText
        
        let sendItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(FloraNotFoundViewController.handleSend(_:)))
        self.navigationItem.rightBarButtonItem = sendItem
        if let image = UIImage(named: "placeholder.png")
        {
            attachedPhotos.append(image)
        }
    }
    
    //MARK: - Email
    
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        
        controller.setToRecipients(["andrewtokeley@gmail.com"])
        controller.setSubject("Flora not found")
        controller.setMessageBody(message.text, isHTML: false)
        
        // add attachments
        var i = 0
        for image in attachedPhotos
        {
            if (image != attachedPhotos.last!)
            {
                i+=1
                
                let imageData = UIImagePNGRepresentation(image)
                controller.addAttachmentData(imageData!, mimeType: "image/png", fileName: "photo_\(i).png")
            }
        }
        
        return controller
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func handleSend(sender: UIBarButtonItem)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    var messageText: String?
    
    func prepareForView(searchTerms: [SearchTerm])
    {
        var searchDescriptions = [String]()
        
        for terms in searchTerms
        {
            searchDescriptions.append("- \(terms.description)")
        }
        
        messageText = "\(MESSAGE_OPENING)\n\n\(searchDescriptions.joinWithSeparator("\n"))"
    }
    
    //MARK: - Photos
    
    var imageRecords: [ImageRecord]
    {
        var imageRecords = [ImageRecord]()
        
        for image in attachedPhotos
        {
            if image != attachedPhotos.last
            {
                imageRecords.append(ImageRecord(image: image))
            }
        }
    
        return imageRecords
    }
    
    //MARK: - ActionSheet
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        if (actionSheet.tag == ACTION_CAPTURE_TAG)
        {
            switch buttonIndex
            {
                case ACTION_TAKE:
                    startCameraControllerFromViewController(UIImagePickerControllerSourceType.Camera, controller: self, delegate: self)
                case ACTION_SELECT:
                    startCameraControllerFromViewController(UIImagePickerControllerSourceType.PhotoLibrary, controller: self, delegate: self)
                default: break
            }
        }
    }

    //MARK: - Taking Photos
    
    func startCameraControllerFromViewController(sourceType: UIImagePickerControllerSourceType, controller: UIViewController, delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)
    {
        
        // Check you have access to camera
        guard (UIImagePickerController.isSourceTypeAvailable(sourceType)) else
        {
            return
        }
        
        let cameraUI = UIImagePickerController()
        cameraUI.sourceType = sourceType
            
        // Displays a control that allows the user to choose picture or
        // movie capture, if both are available:
        if let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)
        {
            cameraUI.mediaTypes = mediaTypes
        }
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        cameraUI.allowsEditing = false
            
        cameraUI.delegate = delegate
        
        controller.presentViewController(cameraUI, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let mediaType = info[UIImagePickerControllerMediaType]
        var originalImage, editedImage: UIImage?
        
        if (CFStringCompare(mediaType as! CFString, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive) == CFComparisonResult.CompareEqualTo)
        {
            editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        // Handle a still image capture
        if let image = editedImage ?? originalImage
        {
            attachedPhotos.insert(image, atIndex: 0)
            collectionView.reloadData()
        }
        
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    }
    
    //MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == SECTION_PHOTO_PERMISSION)
        {
            return 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        if (section == SECTION_PHOTO_PERMISSION)
        {
            return nil
        }
        return super.tableView(tableView, titleForFooterInSection: section)
    }
    
   //MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return attachedPhotos.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
        // Check if the user is clicking the add-image item, which will be last
        if (indexPath.row == attachedPhotos.count - 1)
        {
            // present delete option
            let action = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose Photo")
            action.tag = 0
            action.showInView(self.view)
        }
        else
        {
            photosViewController = NYTPhotosViewController(photos: imageRecords, initialPhoto: imageRecords.first!)
            photosViewController!.delegate = self
            self.presentViewController(photosViewController!, animated: false, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as! ImageCollectionViewCell
        
        cell.image.image = attachedPhotos[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 50)
    }
    
    //
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero // UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    
    //MARK: - PhotoViewer
    
    func photosViewController(photosViewController: NYTPhotosViewController, captionViewForPhoto photo: NYTPhoto) -> UIView? {

        let test = UILabel()
        test.text = "  Remove"
        test.textColor = UIColor.whiteColor()
        test.userInteractionEnabled = true
        test.tag = attachedPhotos.indexOf(photo.image!)!
        
        let clickGesture = UITapGestureRecognizer(target: self, action: #selector(FloraNotFoundViewController.deletePhoto(_:)))
        test.addGestureRecognizer(clickGesture)
        return test
    }
    
    func deletePhoto(sender: UITapGestureRecognizer)
    {
        photosViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        if let label = sender.view as? UILabel
        {
            attachedPhotos.removeAtIndex(label.tag)
            collectionView.reloadData()
        }
    }
}