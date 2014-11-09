//
//  CallViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

class CallViewController: UIViewController, CallInfoDelegate {

    @IBOutlet weak var dialingText: UILabel!
    @IBOutlet weak var progressSpinner: M13ProgressViewRing!
    
    var numberCalling: String = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.callInfoDelegate = self
        progressSpinner.indeterminate = true
        progressSpinner.showPercentage = false
        dialingText.text = "Dialing \(numberCalling)"
    }

    func callDidStartConnecting(connection: TCConnection!) {
        
    }
    
    func callDidConnect(connection: TCConnection!) {
        progressSpinner.performAction(M13ProgressViewActionSuccess, animated: true)
        progressSpinner.indeterminate = false
    }
    
    func callDidDisconnect(connection: TCConnection!) {
        
    }
    
    func callDidFail(connection: TCConnection!, error: NSError!) {
        progressSpinner.performAction(M13ProgressViewActionFailure, animated: true)
        progressSpinner.indeterminate = false
    }
}
