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
    
    var selectedFlora: Flora?
    let RESULTS_LABEL = "RESULTS"
    
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    var selectedSearchResult: SearchResult?
    
    private var leafViewController: LeafViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchResultsCollectionView.registerNib(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        searchResultsCollectionView.delegate = self;
        searchResultsCollectionView.dataSource = self;
        searchResultsCollectionView.backgroundColor = UIColor.whiteColor()
        
        searchResultsCollectionView.layer.borderWidth = 0.5
        searchResultsCollectionView.layer.borderColor = UIColor.defaultTableCellSeparator().CGColor
        
        resultsLabel.text = RESULTS_LABEL
        
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
    }
    
    @IBAction func reset(sender: UIButton)
    {
        self.leafViewController?.reset()
    }
    
    var searchResults: [SearchResult] = []
    {
        didSet
        {
            if (searchResults.count == 0)
            {
                resultsLabel.text = RESULTS_LABEL
                noResultsLabel.hidden = false
            }
            else
            {
                resultsLabel.text = "\(RESULTS_LABEL) (\(searchResults.count))"
                noResultsLabel.hidden = true
            }
            
            searchResultsCollectionView.reloadData()
        }
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
        
        cell.image.image = result.flora.image ?? result.flora.placeholderImage
        cell.label.text = result.flora.commonName!
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let scale = 1.0
        return CGSize(width: 100 * scale, height: 130 * scale)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 10, bottom: 0, right: 10)
    }
    

}