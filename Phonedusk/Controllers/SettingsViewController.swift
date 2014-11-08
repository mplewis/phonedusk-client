//
//  SettingsViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit
import Alamofire

let tokenEndpoint = "http://phonedusk.herokuapp.com/api/capability_token"

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getNewToken() {
        println("Requesting new token...")
        Alamofire.request(.GET, tokenEndpoint).responseString { (request, response, data, error) in
            if (error != nil) {
                println(error)
                return
            }
            let token = data!
            appDelegate.device = TCDevice(capabilityToken: token, delegate: appDelegate)
        }
    }

}
