//
//  ViewFloraViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 20/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class ReferenceViewController: UIViewController, UIWebViewDelegate
{
    let SEGUE_EDIT = "edit"
    let SEGUE_SEARCH_DETAILS = "searchDetails"
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    
    @IBOutlet weak var webView: UIWebView!    
    @IBOutlet weak var failMessage: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var urlRequest: NSURLRequest?
    var flora: Flora?
    var searchResult: SearchResult?
    
    func prepareForView(flora: Flora)
    {
        prepareForView(flora, searchResult: nil)
    }
    
    func prepareForView(flora: Flora, searchResult: SearchResult?)
    {
        self.flora = flora
        self.searchResult = searchResult
        
        self.title = "Reference"
        
        if let urlString = flora.externalURL
        {
            if let url = NSURL(string: urlString)
            {
                self.urlRequest = NSURLRequest(URL: url)
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//    {
//        if (segue.identifier == SEGUE_EDIT)
//        {
//            if let controller = segue.destinationViewController as? FloraViewController
//            {
//                if (flora != nil)
//                {
//                    controller.prepareForEdit(flora!)
//                }
//            }
//        }
//        else if (segue.identifier == SEGUE_SEARCH_DETAILS)
//        {
//            if let controller = segue.destinationViewController as? SearchDetailsViewController
//            {
//                controller.prepareForView(searchResult)
//            }
//        }
//        
//    }
    override func viewDidLoad()
    {
        failMessage.hidden = true
        webView.delegate = self
        spinner.hidesWhenStopped = true
        
        spinner.startAnimating()
        
        if let url = self.urlRequest
        {
            webView.loadRequest(url)
        }
        else
        {
            spinner.stopAnimating()
            failMessage.hidden = false
        }
    }
    
    func configureWebNavigationButtons()
    {
        previousButton.enabled = webView.canGoBack
        nextButton.enabled = webView.canGoForward
    }
    
    @IBAction func nextClick(sender: AnyObject)
    {
        webView.goForward()
    }
    
    @IBAction func previousClick(sender: UIBarButtonItem)
    {
        webView.goBack()
    }
    
    //MARK: WebView
    
    func webViewDidStartLoad(webView: UIWebView) {
        configureWebNavigationButtons()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        spinner.stopAnimating()
        
        configureWebNavigationButtons()
    }
}