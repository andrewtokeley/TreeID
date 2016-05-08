//
//  ImageSelectionViewCell.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 4/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import PureLayout

class ImageSelectionViewCell: UICollectionViewCell
{
    //MARK: - Setup
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(label)
        self.contentView.addSubview(selectionStrip)
        
        //self.backgroundColor = UIColor.grayColor()
    }
    
    override func layoutSubviews()
    {
        
        let labelHeight: CGFloat = showLabel ? 15 : 0
        let PADDING: CGFloat = 8
        
        imageView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        imageView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        imageView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        imageView.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: selectionStrip, withOffset: (labelHeight + PADDING) * -1)
        
        label.autoSetDimension(ALDimension.Height, toSize: labelHeight)
        label.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        label.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        label.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: selectionStrip, withOffset: 0)
        
        selectionStrip.autoSetDimension(ALDimension.Height, toSize: 5)
        selectionStrip.autoSetDimension(ALDimension.Width, toSize: 45)
        selectionStrip.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
        selectionStrip.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)

    }
    
    //MARK: Properties
    
    var showLabel: Bool = true
    {
        didSet
        {
            self.needsUpdateConstraints()
        }
    }
    
    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(10)
        label.textAlignment = NSTextAlignment.Center
        return label
    }()
    
    lazy var selectionStrip: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.leafDarkGreen()
        view.layer.cornerRadius = 4
        return view
    }()
    
}