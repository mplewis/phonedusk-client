//
//  AppDelegate.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit

let baseEndpoint = "https://phonedusk.herokuapp.com/api/"
let tokenEndpoint = "capability_token"
let outgoingEndpoint = "start_call"
let myNumber = "+16125675654"
let username = "test"
let password = "password"

let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
let manager = AFHTTPRequestOperationManager(baseURL: NSURL(string: baseEndpoint))
let reqSerializer = AFHTTPRequestSerializer()
let respSerializer = AFHTTPResponseSerializer()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Set up manager and serializer to use HTTP Basic Auth
        reqSerializer.setAuthorizationHeaderFieldWithUsername(username, password: password)
        respSerializer.acceptableContentTypes = NSSet(array: ["text/plain", "text/html", "application/json"])
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = respSerializer
        
        return true
    }
    
}
