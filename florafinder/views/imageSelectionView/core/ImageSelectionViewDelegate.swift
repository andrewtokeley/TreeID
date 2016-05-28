//
//  ImageSelectionViewDelegate.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 4/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol ImageSelectionViewDelegate {
    func imageSelectionView(imageSelectionView: ImageSelectionView, didSelectItem item: ImageSelectionData?)
    
    //func associatedTableViewCell() -> UITableViewCell?
    
}