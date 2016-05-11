//
//  MeasureLeafViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 17/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import PureLayout

enum MeasureScale
{
    case OneToOne
    case PhoneScale
}

class MeasureLeafViewController: UIViewController
{
    //MARK: - Constants
    
    let PADDING:CGFloat = 20
    let PADDING_SMALL:CGFloat = 4
    let SLIDER_WIDTH:CGFloat = 40
    let TOOLBAR_HEIGHT:CGFloat = 64
    let TOP_NAV_HEIGHT:CGFloat = 64
    
    let SCALE_TITLE = "Scale"
    let SCALE_ONETOONE = "Small leaves"
    let SCALE_PHONE = "Large leaves"
    let CANCEL = "Cancel"
    let DONT_SET = "Clear"
    let TITLE_DEFAULT = "Measure"
    let DONE_BUTTON = "Done"
    
    let HORIZONTAL_SLIDER = 0
    let VERTICAL_SLIDER = 1
    
    var measureRegion: CGRect!
    
    var initialWidthInCM: CGFloat = 0
    var initialHeightInCM: CGFloat = 0
    
    //MARK: - Initialisers
    
    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(widthCM: CGFloat, heightCM: CGFloat, delegate: MeasureLeafDelegate)
    {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        
        self.initialWidthInCM = widthCM
        self.initialHeightInCM = heightCM
        
    }
    
    //MARK: - UIViewController overrides
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
    
        self.title = self.TITLE_DEFAULT
        
        // Define the region used to take measurements
        self.measureRegion = CGRectMake(PADDING, TOP_NAV_HEIGHT + PADDING, UIScreen.mainScreen().bounds.size.width - 2 * PADDING, UIScreen.mainScreen().bounds.size.height - (2 * PADDING + TOOLBAR_HEIGHT + TOP_NAV_HEIGHT))
        
        let containerView = UIView(frame: UIScreen.mainScreen().bounds)
        containerView.backgroundColor = UIColor.whiteColor()
        
        containerView.addSubview(sizeIndicator)
        containerView.addSubview(toolbar)
        containerView.addSubview(phoneGrid)
        containerView.addSubview(grid)
        containerView.addSubview(resizeHandle)
        
        self.navigationItem.rightBarButtonItem = self.setButton
        
        self.view = containerView;
        
        // work out which scale will contain this dimension
        if initialWidthInCM <= maxWidthInCentimetres(MeasureScale.OneToOne) && initialHeightInCM <= maxHeightInCentimetres(MeasureScale.OneToOne)
        {
            scale = MeasureScale.OneToOne
        }
        else if initialWidthInCM <= maxWidthInCentimetres(MeasureScale.PhoneScale) && initialHeightInCM <= maxHeightInCentimetres(MeasureScale.PhoneScale)
        {
            scale = MeasureScale.PhoneScale
        }
        else
        {
            // ABORT!
        }
        
        moveResizeHandleTo(initialWidthInCM, heightCM: initialHeightInCM)
    }
    
    override func loadView() {
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.needsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        
        toolbar.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        toolbar.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        toolbar.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        toolbar.autoSetDimension(ALDimension.Height, toSize: TOOLBAR_HEIGHT)
        
        // centre grids with fixed width and heights - makes it easier for scaling if we know these dimensions
        phoneGrid.autoCenterInSuperview()
        phoneGrid.autoSetDimension(ALDimension.Width, toSize: self.measureRegion.width)
        phoneGrid.autoSetDimension(ALDimension.Height, toSize: self.measureRegion.height)
        
        grid.autoCenterInSuperview()
        grid.autoSetDimension(ALDimension.Width, toSize: self.measureRegion.width)
        grid.autoSetDimension(ALDimension.Height, toSize: self.measureRegion.height)
        
        super.updateViewConstraints()
    }
    
    //MARK: - Properties
    
    var delegate: MeasureLeafDelegate!
    var firstUpdateViewConstraints = true
    
    var scaleFactor: CGFloat
    {
        // return the scale factor for the current scale
        return scaleFactor(scale)
    }
    
    /**
     Return the scale factor for the given measure scale
     */
    func scaleFactor(scale: MeasureScale) -> CGFloat
    {
        switch scale
        {
        case .OneToOne:
            return 1
        case .PhoneScale:
            let phoneWidth = Units.centimetresToPoints(Units.sizeOfPhoneInCentimetres.width)
            let phoneViewWidth:CGFloat = phoneGrid.phoneRectSize.width
            return CGFloat(phoneWidth)/phoneViewWidth
        }
    }
    
    var widthInCentimetres: CGFloat
    {
        return self.sizeIndicator.frame.size.width/Units.centimetresToPoints(1.0) * scaleFactor
    }

    var heightInCentimetres: CGFloat
    {
        return self.sizeIndicator.frame.size.height/Units.centimetresToPoints(1.0) * scaleFactor
    }
    
    var scale: MeasureScale = MeasureScale.OneToOne
    {
        didSet
        {
            phoneGrid.alpha = scale == .OneToOne ? 0 : 1
            grid.alpha = scale == .OneToOne ? 1 : 0
            
        }
    }
    
    lazy var sizeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.leafLightGreen()
        view.alpha = 0.5
        return view
    }()
    
    lazy var resizeHandle: UIView = {
        let containerView = UIView(frame: CGRect(x: 100, y: 100, width: 80, height: 80))
        containerView.userInteractionEnabled = true
       
        let view = UIView(frame: CGRect(x: 35, y: 35, width: 10, height: 10))
        view.backgroundColor = UIColor.leafDarkGreen()
        containerView.addSubview(view)
        
        let drag = UIPanGestureRecognizer(target: self, action: #selector(MeasureLeafViewController.handleDrag(_:)))
        containerView.addGestureRecognizer(drag)
        
        return containerView
    }()
    
    lazy var setButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: self.DONE_BUTTON, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeasureLeafViewController.handleSetButtonClick(_:)))
        return button
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let dontSpecify = UIBarButtonItem(title: self.DONT_SET, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeasureLeafViewController.handleDontSpecifyButtonClick(_:)))
        toolbar.items = [self.scaleButton, spacer, dontSpecify]

        return toolbar
    }()
    
    lazy var scaleButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: self.SCALE_TITLE, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MeasureLeafViewController.handleScaleButtonClick(_:)))
        return button
    }()
    
    
    lazy var phoneGrid: IPhoneGrid = {
        let grid = IPhoneGrid(frame: self.measureRegion, rows: 3, columns: 4)
        grid.userInteractionEnabled = false
        
        // always hidden initially
        grid.alpha = 0
        return grid
    }()
    
    lazy var grid: UIView = {
        let grid = Grid(frame: self.measureRegion, gridSizeInCM: 1.0)
        grid.userInteractionEnabled = false
        return grid
    }()
    
    lazy var actions: UIAlertController = {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: self.SCALE_ONETOONE, style: UIAlertActionStyle.Default, handler:self.handleScaleAction))
        actionSheet.addAction(UIAlertAction(title: self.SCALE_PHONE, style: UIAlertActionStyle.Default, handler:self.handleScaleAction))
        actionSheet.addAction(UIAlertAction(title: self.CANCEL, style: UIAlertActionStyle.Cancel, handler:self.handleScaleAction))
        return actionSheet
    }()
    
    
    //MARK: - Actions
    
    func handleDrag(recognizer: UIPanGestureRecognizer)
    {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view
        {
            let newCentre = CGPointMake(view.center.x + translation.x, view.center.y + translation.y)
            
            if (measureRegion.contains(newCentre))
            {
                moveResizeHandleTo(newCentre)
                recognizer.setTranslation(CGPointMake(0, 0), inView:self.view)
                
            }
        }
    }
    
    func handleSetButtonClick(sender: UIBarButtonItem)
    {
        self.delegate.measureCompleted(self.widthInCentimetres, length: self.heightInCentimetres)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func handleDontSpecifyButtonClick(sender: UIBarButtonItem)
    {
        self.delegate.measureNotDefined()
        self.navigationController?.popViewControllerAnimated(true)
    }

    func handleScaleButtonClick(sender: UIBarButtonItem)
    {
        self.presentViewController(actions, animated: true, completion: nil)
    }
    
    func handleScaleAction(action: UIAlertAction)
    {
        if action.title == SCALE_ONETOONE
        {
            scale = .OneToOne
        }
        else if action.title == SCALE_PHONE
        {
            scale = .PhoneScale
        }
        else if action.title == CANCEL
        {
            return
        }
        
        // use this scaleFactor to toggle between 1:1 and phone scale
        let s = scaleFactor(MeasureScale.PhoneScale)
        
        if (scale == .OneToOne)
        {
            let deltaX = sizeIndicator.frame.size.width * (s - 1)
            let newX = resizeHandle.center.x + deltaX
            
            let deltaY = sizeIndicator.frame.size.height * (s - 1)
            let newY = resizeHandle.center.y - deltaY
            
            moveResizeHandleTo(newX, screenY: newY)
            
        }
        else if (scale == .PhoneScale)
        {
            // reduce th
            let deltaX = sizeIndicator.frame.size.width * ( 1 - 1/s)
            let newX = resizeHandle.center.x - deltaX
            
            let deltaY = sizeIndicator.frame.size.height * ( 1 - 1/s)
            let newY = resizeHandle.center.y + deltaY
            
            moveResizeHandleTo(newX, screenY: newY)
        }
    }

    //MARK: - Functions
    
    func maxHeightInCentimetres(scale: MeasureScale) -> CGFloat
    {
        let scaleFactor = self.scaleFactor(scale)
        return Units.pointsToCentimetre(self.measureRegion.height) * scaleFactor
    }
    
    func maxWidthInCentimetres(scale: MeasureScale) -> CGFloat
    {
        let scaleFactor = self.scaleFactor(scale)
        return Units.pointsToCentimetre(self.measureRegion.width) * scaleFactor
    }

    func moveResizeHandleTo(screenX: CGFloat, screenY: CGFloat)
    {
        let maxX = measureRegion.origin.x + measureRegion.size.width
        let minY = measureRegion.origin.y
        
        let x = screenX > maxX ? maxX : screenX
        let y = screenY < minY ? minY : screenY
        
        resizeHandle.center = CGPointMake(x, y)
        setSizeIndicatorFrame()
    }

    func moveResizeHandleTo(centre: CGPoint)
    {
        moveResizeHandleTo(centre.x, screenY: centre.y)
    }
    
    func moveResizeHandleTo(widthCM: CGFloat, heightCM: CGFloat)
    {
        // convert cms into screen coordinates)
        let x = Units.centimetresToPoints(widthCM)/self.scaleFactor + PADDING
        let y = self.view.frame.size.height - (Units.centimetresToPoints(heightCM)/self.scaleFactor + TOOLBAR_HEIGHT + PADDING)
        
        moveResizeHandleTo(x, screenY: y)
    }
    
    func updateTitle()
    {
        self.title = String(format: "%.1f x %.1f cm", self.widthInCentimetres, self.heightInCentimetres)
    }
    
    func setSizeIndicatorFrame()
    {
        // size indicator is bound to the position of the resizeHandle
        let x = PADDING
        let y = resizeHandle.center.y
        let width = (resizeHandle.center.x - PADDING)
        let height = (self.view.frame.size.height - (y + TOOLBAR_HEIGHT + PADDING))
        
        self.sizeIndicator.frame.origin = CGPoint(x: x, y: y)
        self.sizeIndicator.frame.size = CGSize(width: width, height: height)
        
        self.updateTitle()
    }
}