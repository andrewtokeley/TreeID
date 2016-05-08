//
//  DescriptionList.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 8/03/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import PureLayout
import UIKit
import WebKit

class DescriptionList: UIView
{
    var descriptionListItems: [DescriptionListItem]?
    var webView: WKWebView!
    
    init(descriptionListItems: [DescriptionListItem])
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.descriptionListItems = descriptionListItems
        
        self.loadView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    var descriptionListItemsAsHTML: String
    {
        var html: String = ""
        
        if let items = self.descriptionListItems
        {
            var rows = ""
            for item in items
            {
                rows += "<tr><td>\(item.label)</td><td>\(item.description)</td></tr>"
            }
            
            html = "<html><body style='font-family:arial;color:black;font-size:14px; -webkit-text-size-adjust: none;'><table> \(rows) </table>"
        }
        return html
    }
    
    func loadView()
    {
        webView = WKWebView(frame: self.frame)
        webView.loadHTMLString(descriptionListItemsAsHTML, baseURL: nil)
        self.addSubview(webView!)
        self.webView.autoPinEdgesToSuperviewEdges()
    }
}