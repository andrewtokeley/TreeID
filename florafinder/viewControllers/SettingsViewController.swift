//
//  SettingsViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 20/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import GoogleAPIClient

class SettingsViewController: UITableViewController, ImportDelegate, GoogleDriveDataStoreProviderDelegate
{
    let SECTION_USER = 0
    let ROW_LOGIN = 0
    
    let SECTION_TEST = 2
    let ROW_IMPORT = 0
    let ROW_GOOGLE_IMPORT = 1
    
    let META_FILE_EXTENSION = "meta"
    let GOOGLE_REGISTER_NAME = "TreeIDRegister"
    let LOG_IN = "Sign in"
    let LOG_OUT = "Log out"
    
    var authenticationService: AuthenticationServiceProtocol!
    
    @IBOutlet weak var loginTableViewCell: UITableViewCell!
    
    var googleImportSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        googleImportSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        self.authenticationService = ServiceFactory.shareInstance.authenticationService
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // make sure the Google spinner is reset
        let cell = super.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: ROW_GOOGLE_IMPORT, inSection: SECTION_TEST))
        cell.accessoryView = nil
        
        loginTableViewCell.textLabel?.text = authenticationService.isAuthenticated ? authenticationService.username : LOG_IN
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
        let service = ServiceFactory.shareInstance.authenticationService
        let provider = GoogleDriveDataStoreProvider(service: service)
        
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
    
    func autenticationViewControllerFor(provider: GoogleDriveDataStoreProvider) -> UIViewController
    {
        return self
    }
    
    func importViewController(importViewController: ImportViewController, didImportRecords: Int) {
    
        // clear the cache
        ServiceFactory.shareInstance.imageCacheProvider?.deleteAll({ (result) in
            
            // what would we do with a fail here?
        })
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        
        if (indexPath.section == SECTION_TEST && indexPath.row == ROW_GOOGLE_IMPORT)
        {
            height = authenticationService.isAuthenticated ? height : 0
        }
        
        return height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        if (indexPath.section == SECTION_USER)
//        {
//            if (indexPath.row == ROW_LOGIN)
//            {
//                if authenticationService.isAuthenticated
//                {
//                    // Logging out...
//                    
//                    authenticationService.signOut()
//                    loginTableViewCell.textLabel?.text = LOG_IN
//                    
//                }
//                else
//                {
//                    // Logging in...
//                    
//                    authenticationService.signIn(self, completion: { (isAuthenticated) in
//                        if (isAuthenticated)
//                        {
//                            self.loginTableViewCell.textLabel?.text = self.LOG_OUT
//                        }
//                    })
//                }
//            }
//            
//            let googleIndexPath = NSIndexPath(forRow: ROW_GOOGLE_IMPORT, inSection: SECTION_TEST)
//            tableView.reloadRowsAtIndexPaths([googleIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//        }
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