//
//  AuthenticationServiceProtocol.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 2/06/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol AuthenticationServiceProtocol
{
    func signIn(loginHostController: UIViewController, completion: ((isAuthenticated: Bool) -> Void)?)
    func signOut()
    
    var context: AnyObject? { get }
    var isAuthenticated: Bool { get }
    var username: String { get }
}