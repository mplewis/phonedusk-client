//
//  PhoneViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit
import AddressBookUI

class PhoneViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate, TCDeviceDelegate {

    var device: TCDevice?
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewToken()
        showConnectingHUD()
    }

    @IBAction func selectContact() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson personRef: ABRecord!) {
        let person = APContact(recordRef: personRef, fieldMask: .Default)
        let alertController = UIAlertController(title: nil, message: "Calling \(person.firstName) \(person.lastName)", preferredStyle: .ActionSheet)
        for numberRaw in person.phones {
            if let number = numberRaw as? String {
                let phoneAction = UIAlertAction(title: number, style: .Default) { (_) in
                    self.callNumber(number)
                }
                alertController.addAction(phoneAction)
            } else {
                println(numberRaw)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(cancelAction)

        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func showConnectingHUD() {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud!.labelText = "Connecting to Twilio..."
    }
    
    func showConnectedHUD() {
        if let h = hud {
            h.labelText = "Connected!"
            h.customView = UIImageView(image: UIImage(named: "checkmark"))
            h.mode = MBProgressHUDModeCustomView
            h.hide(true, afterDelay: 1.0)
        }
    }
    
    func deviceDidStartListeningForIncomingConnections(device: TCDevice!) {
        showConnectedHUD()
        println("deviceDidStartListeningForIncomingConnections")
    }
    
    func device(device: TCDevice!, didReceiveIncomingConnection connection: TCConnection!) {
        let caller = connection.parameters[TCConnectionIncomingParameterFromKey] as String
        let alertController = UIAlertController(title: "Incoming call", message: caller, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            connection.reject()
        }
        let accept = UIAlertAction(title: "Accept", style: .Default) { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let callModal = storyboard.instantiateViewControllerWithIdentifier("CallViewController") as CallViewController
            connection.delegate = callModal
            callModal.numberCalling = caller
            callModal.connection = connection
            connection.accept()
            self.presentViewController(callModal, animated: true, completion: nil)
        }
        alertController.addAction(cancel)
        alertController.addAction(accept)
        presentViewController(alertController, animated: true) { () in }
    }
    
    func device(device: TCDevice!, didReceivePresenceUpdate presenceEvent: TCPresenceEvent!) {
        
    }
    
    func device(device: TCDevice!, didStopListeningForIncomingConnections error: NSError!) {
        showConnectingHUD()
    }
    
    // MARK: - Twilio setup methods
    
    func getNewToken() {
        println("Requesting new token...")
        manager.GET(tokenEndpoint, parameters: nil, success: { (operation, response) -> Void in
            let body = NSString(data: response as NSData, encoding: NSUTF8StringEncoding)
            if (body != nil) {
                let token = body!
                self.device = TCDevice(capabilityToken: token, delegate: self)
                self.device?.incomingSoundEnabled = false
                self.device?.outgoingSoundEnabled = false
                self.device?.disconnectSoundEnabled = false
                println("New TCDevice created from token")
            } else {
                println("Got a nil body")
            }
        }, failure: { (operation, error) -> Void in
            println(error)
        })
    }
    
    // MARK: - Call control methods
    
    func callNumber(number: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let callModal = storyboard.instantiateViewControllerWithIdentifier("CallViewController") as CallViewController
        callModal.numberCalling = number
        let connection = device?.connect(["PhoneNumber": number], delegate: callModal)
        callModal.connection = connection
        self.presentViewController(callModal, animated: true, completion: nil)
    }

}
