//
//  ContactsTableViewController.swift
//  Phonedusk
//
//  Created by Matthew Lewis on 11/9/14.
//  Copyright (c) 2014 Kestrel Development. All rights reserved.
//

let sectionTitles = ["Whitelist", "Blacklist"]

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
        for i in 1...5 {
            let contact = Contact()
            contact.name = "James Coughlin"
            contact.number = "(612) 555-1212"
            blacklist.append(contact)
            if (i < 4) {
                whitelist.append(contact)
            }
        }
        super.init(coder:aDecoder)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = editButtonItem()
    }

    func addContact() {
        println("Adding contact")
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
        println(toAddWhite)
        println(toAddBlack)
        println(toDelWhite)
        println(toDelBlack)
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
        cell.textLabel.text = contact.name
        cell.detailTextLabel?.text = contact.number
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
