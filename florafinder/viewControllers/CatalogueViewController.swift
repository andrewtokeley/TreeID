//
//  CatalogueViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 27/02/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class CatalogueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let SEGUE_VIEW = "view"
    let SEGUE_ADD = "add"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        floraService = ServiceFactory.shareInstance.floraService
        
        datasource = floraService.groupByCommonName(floraService.getAll())
        sections = Array(datasource.keys.sort())
    }
    
    //MARK: - Properties
    
    var selectedFlora: Flora?
    
    var floraService: FloraServiceProtocol!
    
    var datasource: [String:[Flora]] = [:]
    var sections: [String] = []
    var alphabet: [String] = ["A", "B", "C", "D", "E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    lazy var allFlora: [Flora] =
    {
        return self.floraService.getAll()
    }()
    
    //MARK: - Segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        return (identifier == SEGUE_VIEW && selectedFlora != nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
            if (segue.identifier == SEGUE_VIEW)
            {
                if let viewController = segue.destinationViewController as? FloraDetailsViewController
                {
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                    viewController.prepareForView(selectedFlora!)                    
                }
            }
            else if (segue.identifier == SEGUE_ADD)
            {
                if let viewController = segue.destinationViewController as? FloraViewController
                {
                    viewController.prepareForAdd()
                }
            }
        
    }
    
    //MARK: - TableView
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return alphabet
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if let newIndex = sections.indexOf(title)
        {
            return newIndex
        }
        else
        {
            // return something close the letter clicked even though nothing mathces
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        {
            let sectionKey = sections[indexPath.section]
            let selectedFlora = datasource[sectionKey]![indexPath.row]
            cell.textLabel?.text = selectedFlora.commonName
            cell.imageView?.image = selectedFlora.image
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.selectedFlora = datasource[sections[indexPath.section]]![indexPath.row]
        return indexPath
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionKey = sections[section]
        return datasource[sectionKey]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}