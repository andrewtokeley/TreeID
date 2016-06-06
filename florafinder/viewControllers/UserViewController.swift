//
//  UserViewController.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 6/06/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class UserViewController: UIViewController
{
    let SIGN_IN_MESSAGE = "Sign in with"
    let SIGN_OUT_MESSAGE = "Sign out of"
    
    @IBOutlet weak var googleSignInView: UIView!
    
    var authenticationService: AuthenticationServiceProtocol!
    
    @IBOutlet weak var signInOutMessageLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        googleSignInView.layer.cornerRadius = 5
        googleSignInView.layer.borderColor = UIColor.lightGrayColor().CGColor
        googleSignInView.layer.borderWidth = 1
        
        authenticationService = ServiceFactory.shareInstance.authenticationService
        
        configureView()
    }
    
    func signInTap(sender: UIView)
    {
        authenticationService.signIn(self, completion: { (isAuthenticated) in
            self.configureView()
        })
    }
    
    func signOutTap(sender: UIView)
    {
        authenticationService.signOut()
        configureView()
    }
    
    func configureView()
    {
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: authenticationService.isAuthenticated ? #selector(self.signOutTap(_:)) : #selector(self.signInTap(_:)))
        googleSignInView.addGestureRecognizer(tap)

        signInOutMessageLabel.text = authenticationService.isAuthenticated ? SIGN_OUT_MESSAGE : SIGN_IN_MESSAGE
        
        messageLabel.text = authenticationService.isAuthenticated ? "You are logged in as \(authenticationService.username)" : "It's only worth signing in if you're andrewtokeley@gmail.com"
    }
    
}