//
//  AppDelegate.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit
import Alamofire

let tokenEndpoint = "http://phonedusk.herokuapp.com/api/capability_token"

let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TCDeviceDelegate, TCConnectionDelegate {

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
        connection!.delegate = self
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
    
    // MARK: - TCConnectionDelegate methods
    
    func connection(connection: TCConnection!, didFailWithError error: NSError!) {
        println("didFailWithError: \(error.localizedDescription)")
    }
    
    func connectionDidStartConnecting(connection: TCConnection!) {
        println("connectionDidStartConnecting")
    }
    
    func connectionDidConnect(connection: TCConnection!) {
        println("connectionDidConnect")
    }
    
    func connectionDidDisconnect(connection: TCConnection!) {
        println("connectionDidDisconnect")
    }
    
    // MARK: - Call control methods
    
    func callNumber(number: String) {
        hangUp()
        device?.connect(["PhoneNumber": number], delegate: self)
    }
    
    func hangUp() {
        connection?.disconnect()
        connection = nil
    }
    
}
