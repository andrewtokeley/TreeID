//
//  ImagePreview.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 29/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import PureLayout

class ImagePreviewViewController: UIViewController
{
    var images: [UIImage]!
    
//    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage)
    {
        self.init(images: [image])
    }
    
    init(images: [UIImage])
    {
        super.init(nibName: nil, bundle: nil)
        
        self.images = images
    }
    
    //MARK: - UIViewController overrides
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        let containerView = UIView(frame: UIScreen.mainScreen().bounds)
        containerView.backgroundColor = UIColor.whiteColor()
        
        containerView.addSubview(imageView)
        containerView.addSubview(closeIcon)
        
        self.view = containerView
    }
    
    override func viewWillAppear(animated: Bool) {
            }
    
    override func updateViewConstraints() {
        
        imageView.autoPinEdgesToSuperviewEdges()
        
        closeIcon.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 8)
        closeIcon.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 8)
        closeIcon.autoSetDimension(ALDimension.Width, toSize: 20)
        closeIcon.autoSetDimension(ALDimension.Height, toSize: 20)
        
        super.updateViewConstraints()
        
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.mainScreen().bounds)
        imageView.image = self.images.first
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        return imageView
    }()
    
    lazy var closeIcon: UIImageView = {
        let image = UIImage(named: "close.png")
        //image?.changeColor(UIColor.whiteColor())
        
        let imageView = UIImageView(image: image)
        imageView.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ImagePreviewViewController.closeTap(_:)))
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    func closeTap(sender: UIImageView)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}