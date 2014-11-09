//
//  CallViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/9/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

class CallViewController: UIViewController, TCConnectionDelegate {
    
    @IBOutlet weak var progressRing: M13ProgressViewRing!
    @IBOutlet weak var callTime: UILabel!
    
    var connection: TCConnection?
    var number: String? {
        didSet {
            navigationItem.title = number
        }
    }
    var seconds = 0
    var timer: NSTimer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.progressRing.indeterminate = true
        self.progressRing.showPercentage = false
        self.connection?.accept()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let t = timer {
            t.invalidate()
        }
    }
    
    func incrementTimer() {
        let minutes = seconds / 60
        var minStr = "\(minutes % 60)"
        if (minutes < 10) {
            minStr = "0" + minStr
        }
        var secStr = "\(seconds % 60)"
        if (seconds < 10) {
            secStr = "0" + secStr
        }
        let time = "\(minStr):\(secStr)"
        callTime.text = time
        seconds += 1
    }

    func connection(connection: TCConnection!, didFailWithError error: NSError!) {
        println("connection:didFailWithError")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func connectionDidConnect(connection: TCConnection!) {
        println("connectionDidConnect")
        progressRing.indeterminate = false
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("incrementTimer"), userInfo: nil, repeats: true)
        })
    }
    
    func connectionDidDisconnect(connection: TCConnection!) {
        println("connectionDidDisconnect")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func connectionDidStartConnecting(connection: TCConnection!) {
        println("connectionDidStartConnecting")
        progressRing.indeterminate = false
    }
    
    @IBAction func hangUp(sender: AnyObject) {
        connection?.disconnect()
    }
    
}
