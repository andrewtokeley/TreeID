//
//  GoogleAuthenticationService.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 2/06/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation
import GoogleAPIClient
import GTMOAuth2

class GoogleAuthenticationService: NSObject, AuthenticationServiceProtocol
{
//    private let ROOT_FOLDER_NAME = "TreeID"
//    private var rootForderID: String?
//    
    private let kKeychainItemName = "Drive API"
    private let kClientID = "630604644095-h99d0gh6sd3ast4tvd0rf23rh5p4kcn0.apps.googleusercontent.com"
    private let scopes = [kGTLAuthScopeDriveMetadataReadonly, kGTLAuthScopeDriveReadonly]
    private let service = GTLServiceDrive()
    private var hostViewController: UIViewController?
    
    private var signInComplete: ((Bool) -> Void)?
    
    //MARK: - Protocol
    
    var isAuthenticated: Bool
    {
        // check if the authentication token is in the KeyChain
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil)
        {
            service.authorizer = auth
        }
        
        // determine if the user is authenticated
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth
        {
            return true
        }
        else
        {
            return false
        }
    }

    func signIn(loginController: UIViewController, completion: ((isAuthenticated: Bool) -> Void)?)
    {
        hostViewController = loginController
        
        loginController.presentViewController(
            createAuthController(),
            animated: true,
            completion: nil
        )
        
        // This should get called once signin is complete
        self.signInComplete = completion

    }
    
    var context: AnyObject?
    {
        return self.service
    }
    
    func signOut()
    {
        GTMOAuth2ViewControllerTouch.removeAuthFromKeychainForName(kKeychainItemName)
        GTMOAuth2ViewControllerTouch.revokeTokenForGoogleAuthentication(service.authorizer as! GTMOAuth2Authentication)
    }
    
    var username: String
    {
        return service.authorizer.userEmail
    }
    
    //MARK: - Helpers
    
    private func createAuthController() -> GTMOAuth2ViewControllerTouch
    {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(self.handleAuth(_:finishedWithAuth:error:))
        )
    }
    
    // Handle completion of the authorization process, and update the Drive API
    // with the new credentials.
    @objc func handleAuth(vc : UIViewController,
                          finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            UIAlertView(title: "Error", message: error.description, delegate: nil, cancelButtonTitle: "Close", otherButtonTitles: "").show()
            return
        }
        else
        {
            service.authorizer = authResult
        }
        
        signInComplete?(isAuthenticated)
        
        hostViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}