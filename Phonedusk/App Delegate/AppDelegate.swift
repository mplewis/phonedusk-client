//
//  AppDelegate.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit

let baseEndpoint = "https://phonedusk-herokuapp-com-qtbo0fcl1ey2.runscope.net/api/"
let tokenEndpoint = "capability_token"
let outgoingEndpoint = "start_call"
let myNumber = "+16125675654"
let username = "test"
let password = "password"

let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: baseEndpoint))
let reqSerializer = AFHTTPRequestSerializer()
let respSerializer = AFHTTPResponseSerializer()

protocol CallInfoDelegate {
    func callDidStartConnecting(connection: TCConnection!)
    func callDidConnect(connection: TCConnection!)
    func callDidDisconnect(connection: TCConnection!)
    func callDidFail(connection: TCConnection!, error: NSError!)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TCDeviceDelegate, TCConnectionDelegate {

    var window: UIWindow?
    var device: TCDevice?
    var connection: TCConnection?
    var callInfoDelegate: CallInfoDelegate?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Set up manager and serializer to use HTTP Basic Auth
        reqSerializer.setAuthorizationHeaderFieldWithUsername(username, password: password)
        respSerializer.acceptableContentTypes = NSSet(array: ["text/plain"])
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = respSerializer
        
        getNewToken()
        return true
    }
    
    // MARK: - Twilio setup methods
    
    func getNewToken() {
        println("Requesting new token...")
        manager.GET(tokenEndpoint, parameters: nil, success: { (operation, response) -> Void in
            println(response)
            let body = NSString(data: response as NSData, encoding: NSUTF8StringEncoding)
            if (body != nil) {
                let token = body!
                self.device = TCDevice(capabilityToken: token, delegate: self)
                println("New TCDevice created from token")
            } else {
                println("Got a nil body")
            }
        }) { (operation, error) -> Void in
            println(error)
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
        println("didFailWithError: \(error)")
        callInfoDelegate?.callDidFail(connection, error: error)
    }
    
    func connectionDidStartConnecting(connection: TCConnection!) {
        println("connectionDidStartConnecting")
        callInfoDelegate?.callDidStartConnecting(connection)
    }
    
    func connectionDidConnect(connection: TCConnection!) {
        println("connectionDidConnect")
        callInfoDelegate?.callDidConnect(connection)
    }
    
    func connectionDidDisconnect(connection: TCConnection!) {
        println("connectionDidDisconnect")
        callInfoDelegate?.callDidDisconnect(connection)
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
