//
//  ImportViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 7/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ImportViewController: UIViewController
{
    //MARK: Properties
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    var importFileURL: NSURL!
    var serviceFactory: ServiceFactory!
    var delegate: ImportDelegate?
    
    //MARK: - Initialisers

    /**
    Shouldn't call this directly, should call the convenience init instead
    **/
    internal override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(nibName nibNameOrNil: String?, serviceFactory: ServiceFactory, fileURL: NSURL, delegate: ImportDelegate)
    {
        self.init(nibName: nibNameOrNil, bundle: nil)
        
        self.importFileURL = fileURL
        self.serviceFactory = serviceFactory
        
        self.delegate = delegate
    }

    override func viewDidLoad()
    {
        messageTextView.text = "Validating file..."
        
        importButton.addTarget(self, action: #selector(ImportViewController.importButtonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        validate()
    }
    
    func importButtonClick(sender: UIButton)
    {
        let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: self.importFileURL)
        
        importer.importFile { (result) in
            if (result.status == TOKImportStatus.Fail)
            {
                self.messageTextView.text = result.messages.summary
            }
            else
            {
                // import successful
                self.delegate?.importViewController(self, didImportRecords: Int(result.validLinesCount))
                self.messageTextView.text = "Success!"
            }
        }
    }
    
    func validate()
    {
        let importer = FloraImporter(serviceFactory: serviceFactory, fileURL: self.importFileURL)
        
        importer.validate { (result) in
            self.messageTextView.text = result.messages.summary
        }
    }
}