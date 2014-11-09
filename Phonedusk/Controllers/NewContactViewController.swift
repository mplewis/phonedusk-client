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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var phoneNumber: String = "" {
        didSet {
            phoneNumberField.text = phoneNumber
            validatePhoneNumber()
        }
    }
    var completionBlock: (number: String) -> Void = { (number) in }
    
    @IBAction func dismissModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectContact() {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveContact(sender: AnyObject) {
        completionBlock(number: phoneNumber)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson personRef: ABRecord!) {
        let person = APContact(recordRef: personRef, fieldMask: .Default)
        if (person.phones.count == 1) {
            self.phoneNumber = person.phones[0] as String
        } else {
            let alertController = UIAlertController(title: nil, message: "Select a number for \(person.firstName) \(person.lastName)", preferredStyle: .ActionSheet)
            for numberRaw in person.phones {
                let number = numberRaw as String
                let phoneAction = UIAlertAction(title: number, style: .Default) { (_) in
                    self.phoneNumber = number
                }
                alertController.addAction(phoneAction)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            alertController.addAction(cancelAction)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func validatePhoneNumber() {
        if (phoneNumberField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0) {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
    
}
