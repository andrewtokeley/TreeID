//
//  AppDelegate.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 2/01/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
    BITHockeyManager.sharedHockeyManager().configureWithIdentifier("2ac3761b3cba43959e578d1df74cbc9b")
        
        // Do some additional configuration if needed here
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
        
        // TESTING - CLEAR DATA CACHE
        ServiceFactory.shareInstance.imageCacheProvider?.deleteAll({ (result) in
            if !result
            {
                // failed to clear cache!
            }
            
        })
        
        Appearance.setAppearance()
        
        return true
    }

    func handleUrl(url: NSURL)
    {
        let root = self.window?.rootViewController?.childViewControllers.first as? HomeViewController
        root?.importData(url)
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
    {
        handleUrl(url)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

