//
//  SearchViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 19/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let SEGUE_VIEW = "viewer"
    let SEGUE_REPORT = "report"
    let RESULTS_SECTION_HEIGHT_COLLAPSED: CGFloat = 40
    let RESULTS_SECTION_HEIGHT_EXPANDED: CGFloat = 150
    
    var imageCache = [String: UIImage]()
    
    @IBOutlet weak var resultsSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var selectedFlora: Flora?
    let RESULTS_LABEL = "RESULTS"
    
    @IBOutlet weak var letUsKnowButton: UIButton!
    @IBOutlet weak var dontSeeLabel: UILabel!
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var resultsLabel: UILabel!
    
    var selectedSearchResult: SearchResult?
    
    private var leafViewController: LeafViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchResultsCollectionView.registerNib(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        searchResultsCollectionView.delegate = self;
        searchResultsCollectionView.dataSource = self;
        
        resultViewsCollapse()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "searchSearchView")
        {
            leafViewController = segue.destinationViewController as? LeafViewController
            
            leafViewController?.prepareForView(SessionStateService.shareInstance.savedSearchState)
            
        }
        if (segue.identifier == SEGUE_VIEW)
        {
            if let viewController = segue.destinationViewController as? FloraDetailsViewController
            {
                if let flora = selectedFlora
                {
                    // get only the search results for this
                    viewController.prepareForView(flora)
                }
            }
        }
        if (segue.identifier == SEGUE_REPORT)
        {
            if let viewController = segue.destinationViewController as? FloraNotFoundViewController
            {
                if let searchItems = leafViewController?.searchTerms
                {
                    viewController.prepareForView(searchItems)
                }
            }
        }
    }
    
    @IBAction func reset(sender: UIButton)
    {
        self.leafViewController?.reset()
    }
    
    var searchResults: [SearchResult] = []
    {
        didSet
        {
            let noResults = self.searchResults.count == 0
            
            if (noResults)
            {
                resultViewsCollapse()
            }
            else
            {
                resultViewsExpand()
            }
            
            
            // animate results section expanding
            
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations:
            {
                () in
                    self.view.layoutIfNeeded()
            },
            completion:
            {
                (result) in
                    if result
                    {
                        self.noResultsLabel.hidden = !noResults
                        self.dontSeeLabel.hidden = noResults
                        self.letUsKnowButton.hidden = noResults
                        self.searchResultsCollectionView.reloadData()
                    }
            })
            
        }
    }
    
    // MARK: Results Views
    
    func resultViewsCollapse()
    {
        resultsSectionHeightConstraint.constant = RESULTS_SECTION_HEIGHT_COLLAPSED

        self.searchResultsCollectionView.backgroundColor = UIColor.clearColor()
        searchResultsCollectionView.layer.borderWidth = 0
        
        self.resultsLabel.text = ""
        self.dontSeeLabel.hidden = true
        self.letUsKnowButton.hidden = true
    }
    
    func resultViewsExpand()
    {
        self.resultsSectionHeightConstraint.constant = self.RESULTS_SECTION_HEIGHT_EXPANDED
        
        searchResultsCollectionView.backgroundColor = UIColor.whiteColor()
        searchResultsCollectionView.layer.borderWidth = 0.5
        searchResultsCollectionView.layer.borderColor = UIColor.defaultTableCellSeparator().CGColor
        
        self.resultsLabel.text = "\(self.RESULTS_LABEL) (\(self.searchResults.count))"
    }
    
    // MARK: CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0)
        {
            return searchResults.count
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
        
        selectedSearchResult = searchResults[indexPath.row]
        selectedFlora = selectedSearchResult?.flora
        
        self.performSegueWithIdentifier(SEGUE_VIEW, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath:indexPath) as! SearchResultCollectionViewCell
        
        let result = searchResults[indexPath.row]
        let session = ServiceFactory.shareInstance.sessionStateService
        
        if let thumbnailName = result.flora.thumbnailName
        {
            // check memory cache
            if let image = session.state[thumbnailName] as? UIImage // imageCache[thumbnailName]
            {
                cell.image.image = image
            }
            else
            {
                let imageService = ServiceFactory.shareInstance.imageService
                
                cell.image.image = imageService.placeholderImage
                
                // Get image asynchronously
                imageService.getImageRecords(thumbnailName, recordFound: { (imageRecord) in
                    
                    if let image = imageRecord.image
                    {
                        // add to a local memory cache
                        if let name = imageRecord.name
                        {
                            session.state[name] = image
                        }
                        cell.image.image = image
                    }
                })
                
            }
        }
        cell.label.text = result.flora.commonName!
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 130)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    

}