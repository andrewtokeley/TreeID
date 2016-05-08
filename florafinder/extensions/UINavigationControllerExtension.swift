//
//  UINavigationControllerExtension.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 28/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController
{
    func pushViewController(viewController: UIViewController, animated: Bool, backButtonText: String)
    {
        let backButton = UIBarButtonItem(title: backButtonText, style: UIBarButtonItemStyle.Plain, target: nil, action: nil);
        self.viewControllers.last?.navigationItem.backBarButtonItem = backButton
        self.pushViewController(viewController, animated: animated)
    }
}