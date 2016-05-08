//
//  SelectorViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 19/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class SelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    //MARK: - Initialisers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(dataSource: NSArray, allowNilSelection: Bool, selectedIndex: Int?, title: String, delegate:SelectorDelegate, tag:String?, selectorItemBlock: (AnyObject) -> SelectorItem)
    {
        self.allowNilSelection = allowNilSelection
        self.dataSource = dataSource
        self.delegate = delegate
        self.selectorItemBlock = selectorItemBlock
        self.tag = tag
        
        if (allowNilSelection)
        {
            if (selectedIndex != nil)
            {
                self.selectedIndex = selectedIndex! + 1
            }
        }
        else
        {
            self.selectedIndex = selectedIndex
        }
        
        super.init(nibName: nil, bundle:nil)
        
        self.title = title
    }

    //MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "SelectorRowWithViewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges()
        super.updateViewConstraints()
    }

    override func viewWillAppear(animated: Bool) {
        self.view.needsUpdateConstraints()
    }
    
    override func loadView() {
        let containerView = UIView(frame: UIScreen.mainScreen().bounds)
        containerView.addSubview(self.tableView)
        self.view = containerView;
    }

    //MARK: - Properties
    var allowNilSelection: Bool
    var noSelectionIndicator: String = ""
    var noSelectionTitle: String = "(not set)"
    
    var selectedIndex: Int?
    var lastSelectedIndex: Int? = nil

    var delegate: SelectorDelegate
    
    var dataSource: NSArray
    
    var tag: String?
    var selectorItemBlock: (AnyObject) -> SelectorItem
    var footerText: String?
    
    var allowMultiSelect: Bool = false
    var hasView: Bool = false
    
    lazy var tableView: UITableView =
    {
        let table =  UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        
       table.registerClass(SelectorRowWithViewTableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self;
        table.dataSource = self;
        return table
    }()
    
    var datasourceForBinding: [SelectorItem]
    {
        var result:[SelectorItem] = []
        
        if (allowNilSelection)
        {
            let notSetItem = SelectorItem(title: noSelectionTitle, subTitle: nil, object: nil)
            
            result.append(notSetItem)
        }
        for item in dataSource
        {
            result.append(selectorItemBlock(item))
        }
        return result
    }
    
    var selectedItem: SelectorItem?
    {
        if let index = selectedIndex
        {
            if (allowNilSelection && selectedIndex == 0)
            {
                return SelectorItem(title: noSelectionIndicator, subTitle: nil, object: nil)
            }
            else
            {
                return datasourceForBinding[index]
            }
            
        }
        return nil
    }
    
    //MARK: - Functions
    
    func selectItemFromList(index: Int)
    {
        lastSelectedIndex = selectedIndex
        selectedIndex = index
    }
    
    func close()
    {
        if (self.navigationController == nil)
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    //MARK: - UITableView
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerText
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectItemFromList(indexPath.row)
        
        if (indexPath.row != self.lastSelectedIndex)
        {
            // Check the new item
            self.tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            // If something else was previously checked, uncheck it
            if let indexOfLast = lastSelectedIndex
            {
                let oldCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: indexOfLast, inSection: 0))
                oldCell?.accessoryType = UITableViewCellAccessoryType.None
                
                // Make sure the last selected
                //self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            // let the delegates know something has been selected
            self.delegate.selector(self, itemSelected: self.selectedItem!)
            
        }
        
        // Close the viewcontroller
        self.close()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.allowNilSelection ? self.dataSource.count + 1 : self.dataSource.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        var cell: SelectorRowWithViewTableViewCell
        if let tryCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        {
            cell = tryCell as! SelectorRowWithViewTableViewCell
        }
        else
        {
            cell = SelectorRowWithViewTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let item = self.datasourceForBinding[indexPath.row]

        cell.rowText.text = item.title
        if (item.view != nil)
        {
            cell.rowView.addSubview(item.view!)
        }
        else
        {
            cell.rowView.hidden = true;
        }
        
//        cell.rowView.backgroundColor = UIColor.blueColor()
        
        if (selectedIndex == indexPath.row || (selectedIndex == nil && indexPath.row == 0 && allowNilSelection))
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.lastSelectedIndex = indexPath.row
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell;
    }
}