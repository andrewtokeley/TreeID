//
//  TableViewCellWithCaret.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 15/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation


class TableViewCellWithCaret: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var caret: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.upCaretImage = upCaretImage?.changeColor(UIColor.darkGrayColor())
        self.downCaretImage = downCaretImage?.changeColor(UIColor.darkGrayColor())
    }
    
    var downCaretImage = UIImage(named: "down-arrow.png")
    var upCaretImage = UIImage(named: "up-arrow.png")
    
    var caretDown: Bool = false
    
    func setState(up: Bool)
    {
        caret.image = up ? upCaretImage : downCaretImage
    }
}