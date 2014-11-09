//
//  NewContactViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/9/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

import AddressBookUI

class NewContactViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {

    @IBOutlet weak var addToSelector: UISegmentedControl!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectContact() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveContact(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson personRef: ABRecord!) {
        let person = APContact(recordRef: personRef, fieldMask: .Default)
        let alertController = UIAlertController(title: nil, message: "Calling \(person.firstName) \(person.lastName)", preferredStyle: .ActionSheet)
        for numberRaw in person.phones {
            if let number = numberRaw as? String {
                let phoneAction = UIAlertAction(title: number, style: .Default) { (_) in
                    self.phoneNumberField.text = number
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
