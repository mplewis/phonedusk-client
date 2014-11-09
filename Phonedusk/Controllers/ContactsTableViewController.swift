//
//  ContactsTableViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/9/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

let sectionTitles = ["Whitelist", "Blacklist"]
let whitelistEndpoint = "whitelist"
let blacklistEndpoint = "blacklist"
let phoneNumberKey = "phone_number"

class ContactsTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var whitelist: [Contact]
    var blacklist: [Contact]
    var toAddWhitelist: [Contact]
    var toDelWhitelist: [Contact]
    var toAddBlacklist: [Contact]
    var toDelBlacklist: [Contact]

    required init(coder aDecoder: NSCoder) {
        whitelist = [Contact]()
        blacklist = [Contact]()
        toAddWhitelist = [Contact]()
        toDelWhitelist = [Contact]()
        toAddBlacklist = [Contact]()
        toDelBlacklist = [Contact]()
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    func loadInitialData() {
        var hud: MBProgressHUD?
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud!.labelText = "Loading contacts..."
        })
        let group = dispatch_group_create()
        var whitelistJson = ""
        var blacklistJson = ""
        dispatch_group_enter(group)
        manager.GET(whitelistEndpoint, parameters: nil, success: { (operation, rawData) -> Void in
            let data = NSString(data: rawData as NSData, encoding: NSUTF8StringEncoding)
            if (data != nil) {
                whitelistJson = data!
            } else {
                println("whitelistJson is nil")
            }
            dispatch_group_leave(group)
        }) { (operation, error) -> Void in
            println(error)
            dispatch_group_leave(group)
        }
        dispatch_group_enter(group)
        manager.GET(blacklistEndpoint, parameters: nil, success: { (operation, rawData) -> Void in
            let data = NSString(data: rawData as NSData, encoding: NSUTF8StringEncoding)
            if (data != nil) {
                blacklistJson = data!
            } else {
                println("whitelistJson is nil")
            }
            dispatch_group_leave(group)
        }) { (operation, error) -> Void in
            println(error)
            dispatch_group_leave(group)
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            hud!.labelText = "Loaded!"
            hud!.customView = UIImageView(image: UIImage(named: "checkmark"))
            hud!.mode = MBProgressHUDModeCustomView
            hud!.hide(true, afterDelay: 1.0)
            let whitelistJsonArray = JSON.parse(whitelistJson).asDictionary?["phone_numbers"]?.asArray?
            let blacklistJsonArray = JSON.parse(blacklistJson).asDictionary?["phone_numbers"]?.asArray?
            for number in whitelistJsonArray! {
                let contact = Contact()
                if let n = number.asString {
                    contact.number = "\(number.asString!)"
                    self.whitelist.append(contact)
                } else {
                    print("Not a string: \(number)")
                }
            }
            for number in blacklistJsonArray! {
                let contact = Contact()
                if let n = number.asString {
                    contact.number = "\(number.asString!)"
                    self.blacklist.append(contact)
                } else {
                    print("Not a string: \(number)")
                }
            }
            self.tableView.reloadData()
        }
    }

    func addContact() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newContactModal = storyboard.instantiateViewControllerWithIdentifier("NewContactNC") as UINavigationController
        let newContactVC = newContactModal.viewControllers![0] as NewContactViewController
        newContactVC.completionBlock = { number, listType in
            let nonNumberChars = NSCharacterSet(charactersInString: "0123456789").invertedSet
            let onlyNumbersArray = number.componentsSeparatedByCharactersInSet(nonNumberChars) as NSArray
            let onlyNumbers = onlyNumbersArray.componentsJoinedByString("") as NSString
            var lastNine: String = ""
            if (onlyNumbers.length > 9) {
                lastNine = onlyNumbers.substringFromIndex(onlyNumbers.length - 10)
            } else {
                lastNine = onlyNumbers
            }
            let fullNumber = "+1" + lastNine
            let contact = Contact()
            contact.number = fullNumber
            self.tableView.beginUpdates()
            var row: Int = -1
            var section: Int = -1
            if (listType == .Whitelist) {
                row = self.whitelist.count
                section = 0
                self.whitelist.append(contact)
                self.toAddWhitelist.append(contact)
            } else {
                row = self.blacklist.count
                section = 1
                self.blacklist.append(contact)
                self.toAddBlacklist.append(contact)
            }
            let path = NSIndexPath(forRow: row, inSection: section)
            self.tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }

        self.presentViewController(newContactModal, animated: true, completion: nil)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if (editing) {
            toAddWhitelist = [Contact]()
            toDelWhitelist = [Contact]()
            toAddBlacklist = [Contact]()
            toDelBlacklist = [Contact]()
            let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addContact"))
            navigationItem.leftBarButtonItem = addButton
        } else {
            navigationItem.leftBarButtonItem = nil
            commitChanges(toAddWhite: toAddWhitelist, toAddBlack: toAddBlacklist, toDelWhite: toDelWhitelist, toDelBlack: toDelBlacklist)
        }
    }
    
    func commitChanges(#toAddWhite: [Contact], toAddBlack: [Contact], toDelWhite: [Contact], toDelBlack: [Contact]) {
        let totalChanges = toAddBlack.count + toAddWhite.count + toDelBlack.count + toDelWhite.count
        if (totalChanges > 0) {
            println("Committing all changes")
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "Saving changes..."
            let group = dispatch_group_create()
            for contact in toAddWhite {
                dispatch_group_enter(group)
                manager.POST(whitelistEndpoint, parameters: [phoneNumberKey: contact.number], success: { (operation, rawData) -> Void in
                    println("POSTed to \(whitelistEndpoint)")
                    dispatch_group_leave(group)
                    }, failure: { (operation, error) -> Void in
                        println(error)
                        dispatch_group_leave(group)
                })
            }
            for contact in toAddBlack {
                dispatch_group_enter(group)
                manager.POST(blacklistEndpoint, parameters: [phoneNumberKey: contact.number], success: { (operation, rawData) -> Void in
                    println("POSTed to \(blacklistEndpoint)")
                    dispatch_group_leave(group)
                    }, failure: { (operation, error) -> Void in
                        println(error)
                        dispatch_group_leave(group)
                })
            }
            for contact in toDelWhite {
                dispatch_group_enter(group)
                manager.DELETE(whitelistEndpoint, parameters: [phoneNumberKey: contact.number], success: { (operation, rawData) -> Void in
                    println("DELETEd to \(whitelistEndpoint)")
                    dispatch_group_leave(group)
                    }, failure: { (operation, error) -> Void in
                        println(error)
                        dispatch_group_leave(group)
                })
            }
            for contact in toDelBlack {
                dispatch_group_enter(group)
                manager.DELETE(blacklistEndpoint, parameters: [phoneNumberKey: contact.number], success: { (operation, rawData) -> Void in
                    println("DELETEd to \(blacklistEndpoint)")
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
        } else {
            println("No changes to commit")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return whitelist.count
        } else {
            return blacklist.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as UITableViewCell
        var contact = Contact()
        if (indexPath.section == 0) {
            contact = whitelist[indexPath.row]
        } else {
            contact = blacklist[indexPath.row]
        }
        cell.textLabel.text = contact.number
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            tableView.beginUpdates()
            if (indexPath.section == 0) {
                toDelWhitelist.append(whitelist.removeAtIndex(indexPath.row))
            } else {
                toDelBlacklist.append(blacklist.removeAtIndex(indexPath.row))
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
