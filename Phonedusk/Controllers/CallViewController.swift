//
//  CallViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/8/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

enum CallState {
    case Dialing, StartedConnecting, Connected, Disconnected, Failed
}

class CallViewController: UIViewController, CallInfoDelegate {

    @IBOutlet weak var dialingText: UILabel!
    @IBOutlet weak var progressSpinner: M13ProgressViewRing!
    
    var numberCalling: String = ""
    var callState: CallState = .Dialing
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        progressSpinner.indeterminate = true
        progressSpinner.showPercentage = false
        dialingText.text = "Setting up call..."
    }

    @IBAction func hangUp() {
        appDelegate.hangUp()
        if (callState != .StartedConnecting && callState != .Connected) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func callDidStartConnecting(connection: TCConnection!) {
        dialingText.text = "Calling \(numberCalling)..."
        callState = .StartedConnecting
    }
    
    func callDidConnect(connection: TCConnection!) {
        dialingText.text = "Connected to \(numberCalling)"
        progressSpinner.performAction(M13ProgressViewActionSuccess, animated: true)
        progressSpinner.indeterminate = false
        callState = .Connected
    }
    
    func callDidDisconnect(connection: TCConnection!) {
        dialingText.text = "Call to \(numberCalling) ended"
        progressSpinner.performAction(M13ProgressViewActionNone, animated: true)
        progressSpinner.setProgress(1, animated: false)
        callState = .Disconnected
    }
    
    func callDidFail(connection: TCConnection!, error: NSError!) {
        dialingText.text = "Call failed to \(numberCalling)"
        progressSpinner.performAction(M13ProgressViewActionFailure, animated: true)
        progressSpinner.indeterminate = false
        callState = .Failed
    }
}
