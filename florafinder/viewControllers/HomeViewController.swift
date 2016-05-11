//
//  HomeViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 11/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class HomeViewController: UIViewController, ImportDelegate
{

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    func importData(url: NSURL)
    {
        // Currently the HomeViewController will always look at main serviceFactory, and you can't inject the test version...
        let importViewController = ImportViewController(nibName: "Import", serviceFactory: ServiceFactory.shareInstance, fileURL: url, delegate: self)
        self.navigationController?.pushViewController(importViewController, animated: true)
    }
    
    func importViewController(importViewController: ImportViewController, didImportRecords: Int) {
        // do nothing for now
    }
    
    override func viewDidLoad() {
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Default
        //self.view.backgroundColor = UIColor.leafGreen()
        settingsButton.tintColor = UIColor.leafDarkGreen()
    }
}