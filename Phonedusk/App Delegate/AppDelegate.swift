//
//  AppDelegate.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit
import Alamofire

let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TCDeviceDelegate {

    var window: UIWindow?
    var device: TCDevice?
    var connection: TCConnection?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        getNewToken()
        return true
    }
    
    // MARK: - Twilio setup methods
    func getNewToken() {
        Alamofire.request(.GET, tokenEndpoint).responseString { (request, response, data, error) in
            if (error != nil) {
                println(error)
                return
            }
            let token = data!
            appDelegate.device = TCDevice(capabilityToken: token, delegate: appDelegate)
        }
    }
    
    // MARK: - TCDeviceDelegate methods
    
    func device(device: TCDevice!, didReceiveIncomingConnection newConnection: TCConnection!) {
        println("didReceiveIncomingConnection")
        hangUp()
        connection = newConnection
        connection!.accept()
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
    
    // MARK: - Call control methods
    
    func hangUp() {
        connection?.disconnect()
        connection = nil
    }
    
}
