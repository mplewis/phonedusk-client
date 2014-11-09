//
//  SettingsViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit

let tokenEndpoint = "http://phonedusk.herokuapp.com/api/capability_token"

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getNewToken() {
        println("Requesting new token...")
        appDelegate.getNewToken()
    }

}
