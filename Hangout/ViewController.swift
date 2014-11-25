//
//  ViewController.swift
//  Hangout
//
//  Created by Recognos on 07/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //This is our Activity tableView
    @IBOutlet var activityTable: UITableView!

    var userEmail:String = ""
    var userName:String = ""
    var formater = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Activities"
        self.saveAuthUser()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveAuthUser(){
        if (PersistenceHelper.loadUserFromCoreData(self.userEmail).count > 0){
            //show his activities
        }
        else {
            PersistenceHelper.removeUserFromCoreData()
            PersistenceHelper.saveUserToCoreData(self.userEmail, name: self.userName)
        }

    }

    override func viewWillAppear(animated: Bool) {
        activityTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actManager.activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")!
    
        //Assigning content of the var "activityItems" to  the textLabel of each cell
        cell.textLabel?.text = actManager.activities[indexPath.row].title
    
        formater.dateFormat = "E d MMM hh:mm"
        if let happening = actManager.activities[indexPath.row].startsOn{
            cell.detailTextLabel?.text = "Happenning on " + formater.stringFromDate(happening)
        }
        cell.textLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.textColor = UIColor.redColor()
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Create instance of DetailViewController
        var detail:DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
 
        //Reference DetailViewController's var "cellNAme" and assign it to DetailViewController's var "activityItems"
        detail.cellName = actManager.activities[indexPath.row].title
        detail.cellDesc = "Initiated by " + actManager.activities[indexPath.row].initiator.name as String

        detail.place = actManager.activities[indexPath.row].place
        if let startsOn = actManager.activities[indexPath.row].startsOn{
            detail.cellStartsOn = "Happening on " + formater.stringFromDate(startsOn)
        }
        detail.confirmedMembers = actManager.activities[indexPath.row].confirmedMembers
        detail.pendingMembers = actManager.activities[indexPath.row].pendingMembers
        
        //Programmatically push to associated VC (DetailViewController)
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            actManager.removeActivity(indexPath.row)
            activityTable.reloadData()
        }
    }
}

