//
//  PhoneViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import UIKit
import AddressBookUI

class PhoneViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func selectContact() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func hangUp() {
        appDelegate.hangUp()
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson personRef: ABRecord!) {
        let person = APContact(recordRef: personRef, fieldMask: .Default)
        let alertController = UIAlertController(title: nil, message: "Calling \(person.firstName) \(person.lastName)", preferredStyle: .ActionSheet)
        for numberRaw in person.phones {
            if let number = numberRaw as? String {
                let phoneAction = UIAlertAction(title: number, style: .Default) { (_) in
                    appDelegate.callNumber(number)
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

}
