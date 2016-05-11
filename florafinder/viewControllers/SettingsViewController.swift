//
//  SettingsViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 20/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController, ImportDelegate
{
    let SECTION_TEST = 2
    let ROW_IMPORT = 0

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackOpaque
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

    func importViewController(importViewController: ImportViewController, didImportRecords: Int) {
    
        let _ = try? ServiceFactory.shareInstance.imageDataProvider?.deleteAll()
        let _ = try? ServiceFactory.shareInstance.imageCacheProvider?.deleteAll()
        
        // Simulate files existing in a remote data store (like S3) by moving the files located in the app bundle there.
        for flora in ServiceFactory.shareInstance.floraService.getAll()
        {
            if let imagePath = flora.imagePath
            {
                if let image = UIImage(named: imagePath)
                {
                    ServiceFactory.shareInstance.imageDataProvider?.uploadImage(image, relativePath: imagePath)
                }
                else
                {
                    
                }
            }
        }
    }
    
    func rebuildDatastore()
    {
        do
        {
            try ServiceFactory.shareInstance.dataManagementService.rebuildDatabase()
            
        }
        catch
        {
            // what to do?
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.section == SECTION_TEST)
        {
            if (indexPath.row == ROW_IMPORT)
            {
                if let path = NSBundle.mainBundle().pathForResource("TestImport", ofType: "csv")
                {
                    //rebuildDatastore()
                    importTestFile(path)
                }
                else
                {
                    // no can do, report to user
                }

            }
        }
    }
    
    
}