//
//  FloraViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 8/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class FloraViewController: UITableViewController
{
    var flora: Flora?
    
    @IBOutlet weak var commonNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func prepareForAdd()
    {
        self.title = "New"
    }
    
    func prepareForEdit(flora: Flora)
    {
        self.flora = flora
        self.title = flora.commonName
    }
    
    func configureView()
    {
        commonNameTextField.text = self.flora?.commonName
    }
    
}