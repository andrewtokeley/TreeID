//
//  SearchDetailsViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 24/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class SearchDetailsViewController: UITableViewController
{
    var searchResult: SearchResult?
    
    func prepareForView(searchResult: SearchResult?)
    {
        self.searchResult = searchResult
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = self.searchResult?.searchTermResultDetails[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResult = searchResult
        {
            return searchResult.searchTermResultDetails.count
        }
        else
        {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let PADDING: CGFloat = 12
        if let text = self.searchResult?.searchTermResultDetails[indexPath.row]
        {
            let requiredSize = text.heightWithConstrainedWidth(tableView.frame.size.width, font: UIFont.systemFontOfSize(16)) + 2 * PADDING
            
            return requiredSize
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
}