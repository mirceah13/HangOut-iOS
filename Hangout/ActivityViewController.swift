//
//  ViewController.swift
//  Hangout
//
//  Created by Recognos on 07/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //This is our Activity tableView
    @IBOutlet var activityTable: UITableView!

    var userEmail:String = ""
    var userName:String = ""
    var screenType:ActivityScreenType = ActivityScreenType.JoinableActivities
    var formater = NSDateFormatter()
    var activities:[Activity] = []
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Activities"
        self.saveAuthUser()
        activities = persistenceHelper.list(Individual(name: self.userName, email: self.userEmail, profileUrl: ""), type: self.screenType) as [Activity]
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
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")!
    
        //Assigning content of the var "activityItems" to  the textLabel of each cell
        cell.textLabel?.text = activities[indexPath.row].title
    
        formater.dateFormat = "E d MMM hh:mm"
        if let happening = activities[indexPath.row].startsOn{
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
        detail.cellName = activities[indexPath.row].title
        detail.cellDesc = "Initiated by " + activities[indexPath.row].initiator.name as String

        detail.place = activities[indexPath.row].place
        if let startsOn = activities[indexPath.row].startsOn{
            detail.cellStartsOn = "Happening on " + formater.stringFromDate(startsOn)
        }
        detail.confirmedMembers = activities[indexPath.row].confirmedMembers
        detail.pendingMembers = activities[indexPath.row].pendingMembers
        
        //Programmatically push to associated VC (DetailViewController)
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}

