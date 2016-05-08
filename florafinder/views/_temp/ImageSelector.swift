//
//  ImageSelector.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 23/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import PureLayout

class ImageSelector: UIView
{
    var delegate: ImageSelectorDelegate?
    var indicatorLeadingOffsetConstraint: NSLayoutConstraint?
    var identifier: String?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        loadView()
    }
    
    func loadView()
    {
        self.addSubview(imageStackView)
        self.addSubview(labelStackView)
        self.addSubview(selectionIndicator)
        
        self.indicatorLeadingOffsetConstraint = selectionIndicator.autoPinEdgeToSuperviewEdge(ALEdge.Leading, withInset: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = self.delegate!.numberOfItemsInImageSelector(self)

        if (imageStackView.arrangedSubviews.count == 0)
        {
            
            for i in 0...count - 1
            {
                if let image = self.delegate!.imageSelector(self, itemForIndex: i)?.image
                {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = UIViewContentMode.Center
                    imageView.userInteractionEnabled = true
                    imageView.tag = i
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(ImageSelector.handleTap(_:)))
                    imageView.addGestureRecognizer(tap)
                    
                    imageStackView.addArrangedSubview(imageView)
                }
            }
        }
        
        if (labelStackView.arrangedSubviews.count == 0)
        {
            for i in 0...count - 1
            {
                if let caption = self.delegate!.imageSelector(self, itemForIndex: i)?.caption
                {
                    let label = UILabel()
                    label.text = caption
                    label.font = UIFont.systemFontOfSize(12)
                    label.textAlignment = NSTextAlignment.Center
                    label.userInteractionEnabled = true
                    label.tag = i
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(ImageSelector.handleTap(_:)))
                    label.addGestureRecognizer(tap)
                    
                    labelStackView.addArrangedSubview(label)
                }
            }
        }
        
    }
    
    //MARK: - Tap
    
    func removeSelection()
    {
        selectionIndicator.hidden = true
    }
    
    func moveSelectionIndicatorToPosition(index: Int)
    {
        let imageCentreX = imageStackView.arrangedSubviews[index].frame.origin.x + imageStackView.arrangedSubviews[index].frame.size.width / 2
        
        let indicatorPosition = imageCentreX - selectionIndicator.frame.size.width / 2
        
        selectionIndicator.hidden = false
        
        self.indicatorLeadingOffsetConstraint?.constant = indicatorPosition
        UIView.animateWithDuration(Double(0.2), animations: {
            self.layoutIfNeeded()
        })
    }
    
    func handleTap(sender: UITapGestureRecognizer)
    {
        if let index = sender.view?.tag
        {
            moveSelectionIndicatorToPosition(index)
            delegate?.imageSelector(self, didSelectIndex: index)
        }
    }
    
    //MARK: - Constraints
    
    override func updateConstraints() {
        super.updateConstraints()

        imageStackView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        imageStackView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        imageStackView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        imageStackView.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: labelStackView)
        
        labelStackView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        labelStackView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        labelStackView.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: selectionIndicator)
        //labelStackView.autoSetDimension(ALDimension.Height, toSize: 20)
        
        selectionIndicator.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        selectionIndicator.autoSetDimension(ALDimension.Width, toSize: 50)
        selectionIndicator.autoSetDimension(ALDimension.Height, toSize: 10)
        
    }
    
    //MARK: - SubViews

    lazy var selectionIndicator: UIView =
        {
            let view = UIView()
            view.backgroundColor = UIColor.leafDarkGreen()
            view.layer.cornerRadius = 4
            view.hidden = true // initial state is unselected
            return view
    }()
    
    lazy var imageStackView: UIStackView =
    {
        let view = UIStackView()
        view.axis = UILayoutConstraintAxis.Horizontal
        view.alignment = UIStackViewAlignment.Fill
        view.distribution = UIStackViewDistribution.FillEqually
        
        return view
    }()
    
    lazy var labelStackView: UIStackView =
    {
        let view = UIStackView()
        view.axis = UILayoutConstraintAxis.Horizontal
        view.alignment = UIStackViewAlignment.Fill
        view.distribution = UIStackViewDistribution.FillEqually
        
        return view
    }()
    
}
