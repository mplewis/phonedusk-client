//
//  AppDelegate.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TCDeviceDelegate {

    var window: UIWindow?
    var device: TCDevice?
    var connection: TCConnection?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: - TCDeviceDelegate methods
    
    func device(device: TCDevice!, didReceiveIncomingConnection connection: TCConnection!) {
        println("didReceiveIncomingConnection")
    }
    
    func device(device: TCDevice!, didReceivePresenceUpdate presenceEvent: TCPresenceEvent!) {
        println("didReceivePresenceUpdate")
    }
    
    func device(device: TCDevice!, didStopListeningForIncomingConnections error: NSError!) {
        println("didStopListeningForIncomingConnections")
    }
    
    func deviceDidStartListeningForIncomingConnections(device: TCDevice!) {
        println("deviceDidStartListeningForIncomingConnections")
    }
    
}

