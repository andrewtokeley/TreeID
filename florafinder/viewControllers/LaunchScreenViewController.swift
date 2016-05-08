//
//  LaunchScreenViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 1/05/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class LaunchScreenViewController: UIViewController {
    
    override func loadView() {
        self.view.backgroundColor = UIColor.leafDarkGreen()
        
        
    }
    
    override func updateViewConstraints() {
        logo.autoCenterInSuperview()
    }
    
    lazy var logo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "individual.png"))
        return logo
    }()
}