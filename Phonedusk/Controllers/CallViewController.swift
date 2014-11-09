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

class CallViewController: UIViewController, TCConnectionDelegate {

    @IBOutlet weak var dialingText: UILabel!
    @IBOutlet weak var progressSpinner: M13ProgressViewRing!
    
    var connection: TCConnection?
    var numberCalling: String = ""
    var callState: CallState = .Dialing
    var dialingTimeoutTimer: NSTimer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        progressSpinner.indeterminate = true
        progressSpinner.showPercentage = false
        dialingText.text = "Setting up call..."
        dialingTimeoutTimer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: Selector("checkDialingTimeout"), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        dialingTimeoutTimer?.invalidate()
    }
    
    func hangUp() {
        connection?.disconnect()
    }

    @IBAction func hangUpClicked() {
        hangUp()
        if (callState != .StartedConnecting && callState != .Connected) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func checkDialingTimeout() {
        if (callState == .Dialing) {
            hangUp()
            showCallFailure()
        }
    }
    
    func showCallFailure() {
        dialingText.text = "Call failed to \(numberCalling)"
        progressSpinner.performAction(M13ProgressViewActionFailure, animated: true)
        progressSpinner.indeterminate = false
        callState = .Failed
    }
    
    func connectionDidStartConnecting(connection: TCConnection!) {
        dialingText.text = "Connecting to \(numberCalling)..."
        callState = .StartedConnecting
    }
    
    func connectionDidConnect(connection: TCConnection!) {
        dialingText.text = "Connected to \(numberCalling)"
        progressSpinner.performAction(M13ProgressViewActionNone, animated: true)
        progressSpinner.indeterminate = false
        callState = .Connected
    }

    func connectionDidDisconnect(connection: TCConnection!) {
        dialingText.text = "Call to \(numberCalling) ended"
        progressSpinner.performAction(M13ProgressViewActionSuccess, animated: true)
        progressSpinner.indeterminate = false
        callState = .Disconnected
    }
    
    func connection(connection: TCConnection!, didFailWithError error: NSError!) {
        showCallFailure()
    }
}
