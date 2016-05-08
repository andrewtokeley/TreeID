//
//  Semaphore.swift
//  florafinder
//
//  Created by Andrew Tokeley  on 5/04/16.
//  Copyright © 2016 Andrew Tokeley . All rights reserved.
//

import Foundation

class Semaphore: NSObject
{
    private var flags:NSMutableDictionary
    
    static var sharedInstance: Semaphore =
    {
        return Semaphore()
    }()
    
    override init()
    {
        self.flags = NSMutableDictionary(capacity: 10)
        super.init()
    }
    
    func isLifted(key: String) -> Bool
    {
        return self.flags.objectForKey(key) != nil
    }
    
    func lift(key: String)
    {
        //[self.flags setObject:@"YES" forKey: key];
        self.flags.setObject("YES", forKey: key)
    }
    
    func waitForKey(key: String)
    {
        var keepRunning = true
        while (keepRunning && NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: 1.0)))
        {
            //keepRunning = ![[TestSemaphor sharedInstance] isLifted: key];
            keepRunning = !Semaphore.sharedInstance.isLifted(key)
        }
    }
}