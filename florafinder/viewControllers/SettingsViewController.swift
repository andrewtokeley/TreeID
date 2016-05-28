//
//  SettingsViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 20/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController, ImportDelegate, GoogleDriveDataStoreProviderDelegate
{
    let SECTION_TEST = 2
    let ROW_IMPORT = 0
    let ROW_GOOGLE_IMPORT = 1
    
    let META_FILE_EXTENSION = "meta"
    let GOOGLE_REGISTER_NAME = "TreeIDRegister"
    
    var googleImportSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        googleImportSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // make sure the Google spinner is reset
        let cell = super.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: ROW_GOOGLE_IMPORT, inSection: SECTION_TEST))
        cell.accessoryView = nil
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(sender: UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func importTestFile(path: String)
    {
        let url = NSURL(fileURLWithPath: path)
        
        let importViewController = ImportViewController(nibName: "Import", serviceFactory: ServiceFactory.shareInstance, fileURL: url, delegate: self)
        
        self.navigationController?.pushViewController(importViewController, animated: true)
    }

    func importFromGoogle()
    {
        let provider = GoogleDriveDataStoreProvider(delegate: self)
        
        provider.authenticate({ (isAuthenticated) in
            if (isAuthenticated)
            {
                self.googleImportSpinner?.startAnimating()

                provider.getFile(self.GOOGLE_REGISTER_NAME, completion: { (file) in
                    
                    // the CSV code requires a NSURL pointing to the CSV data
                    if let _ = file
                    {
                        // could save NSData to file and use URL to this instead
                        if let url = ServiceFactory.shareInstance.imageCacheProvider?.uploadFile(file!, relativePath: "import.csv")
                        {
                            let importViewController = ImportViewController(nibName: "Import", serviceFactory: ServiceFactory.shareInstance, fileURL: url, delegate: self)
                        
                            self.navigationController?.pushViewController(importViewController, animated: true)
                        }
                    }
                    
                    self.googleImportSpinner?.stopAnimating()
                })
                
            }
        })
    }
    
    func autenticationViewControllerFor(provider: GoogleDriveDataStoreProvider) -> UIViewController
    {
        return self
    }
    
    func importViewController(importViewController: ImportViewController, didImportRecords: Int) {
    
        // clear the cache
        let _ = try? ServiceFactory.shareInstance.imageCacheProvider?.deleteAll()
    }
    
//    func rebuildDatastore()
//    {
//        do
//        {
//            try ServiceFactory.shareInstance.dataManagementService.rebuildDatabase()
//            
//        }
//        catch
//        {
//            // what to do?
//        }
//    }
//    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.section == SECTION_TEST)
        {
            if (indexPath.row == ROW_IMPORT)
            {
                if let path = NSBundle.mainBundle().pathForResource("TestImport", ofType: "csv")
                {
                    importTestFile(path)
                }
                else
                {
                    // no can do, report to user
                }

            }
            else if (indexPath.row == ROW_GOOGLE_IMPORT)
            {
                googleImportSpinner.frame = CGRectMake(0, 0, 24, 24);
                if let cell = tableView.cellForRowAtIndexPath(indexPath)
                {
                    cell.accessoryView = googleImportSpinner
                }
                importFromGoogle()
            }
        }
    }
    
    
}