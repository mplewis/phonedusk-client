//
//  SettingsViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit

let blacklistEndpoints = ["enable": "blacklist/enable", "disable": "blacklist/disable"]
let whitelistEndpoints = ["enable": "whitelist/enable", "disable": "whitelist/disable"]

class SettingsViewController: UIViewController {

    @IBOutlet weak var privacyMode: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveSettings(sender: UIBarButtonItem) {
        var enableBlacklist = false
        var enableWhitelist = false
        if (privacyMode.selectedSegmentIndex == 0) {
            enableWhitelist = true
        } else if (privacyMode.selectedSegmentIndex == 1) {
            enableBlacklist = true
        }
        var endpoints = [String]()
        if (enableBlacklist) {
            endpoints.append(blacklistEndpoints["enable"]!)
        } else {
            endpoints.append(blacklistEndpoints["disable"]!)
        }
        if (enableWhitelist) {
            endpoints.append(whitelistEndpoints["enable"]!)
        } else {
            endpoints.append(whitelistEndpoints["disable"]!)
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Saving settings..."
        let group = dispatch_group_create()
        for endpoint in endpoints {
            dispatch_group_enter(group)
            manager.POST(endpoint, parameters: nil, success: { (operation, response) -> Void in
                println("POSTed to \(endpoint)")
                dispatch_group_leave(group)
            }, failure: { (operation, error) -> Void in
                println(error)
                dispatch_group_leave(group)
            })
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            hud.labelText = "Saved!"
            hud.customView = UIImageView(image: UIImage(named: "checkmark"))
            hud.mode = MBProgressHUDModeCustomView
            hud.hide(true, afterDelay: 1.0)
        }
        
    }

}
