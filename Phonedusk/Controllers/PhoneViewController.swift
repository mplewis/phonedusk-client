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
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson personRef: ABRecord!) {
        let person = APContact(recordRef: personRef, fieldMask: .Default)
        println("\(person.lastName), \(person.firstName): \(person.phones)")
    }

}
