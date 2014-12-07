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
    var user:Individual = Individual()
    var screenType:ActivityScreenType = ActivityScreenType.JoinableActivities
    var formater = NSDateFormatter()
    var activities:[Activity] = []
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Activities"
        self.saveAuthUser()
        activities = persistenceHelper.list(self.user, type: self.screenType) as [Activity]

        if (self.activities.count == 0 || (self.activities.count == 1 && self.activities[0].getId() == "" )){
            let nothingLabel = UILabel(frame: CGRectMake(55, 285, 240, 30))
            nothingLabel.font = UIFont(name: "Avenir", size: 15)

            nothingLabel.text = "Nothing to see here...move along"
            nothingLabel.textColor = UIColor.whiteColor()
            
            self.view.addSubview(nothingLabel)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveAuthUser(){
        if (PersistenceHelper.loadUserFromCoreData(self.user.email).count > 0){
            //show his activities
        }
        else {
            PersistenceHelper.removeUserFromCoreData()
            PersistenceHelper.saveUserToCoreData(self.user.email, name: self.user.name)
        }

    }

    override func viewWillAppear(animated: Bool) {
        activityTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.rowHeight = 64.0
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TableView")!
    
        let rowActivity = activities[indexPath.row]
        //Assigning content of the var "activityItems" to  the textLabel of each cell
        cell.textLabel?.text = activities[indexPath.row].title
    
        formater.dateFormat = "E d MMM hh:mm"
        if let happening = activities[indexPath.row].startsOn{
            cell.detailTextLabel?.text = "Happenning on " + formater.stringFromDate(happening)
        }
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.textLabel?.font = UIFont(name: "Avenir", size: 15)
        cell.detailTextLabel?.textColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 10)
        cell.backgroundColor = UIColor.clearColor()
        
        var color = UIColor.whiteColor()
        let initiatorlbl = UILabel(frame: CGRectMake(0, 0, 200, 21))
        initiatorlbl.textColor = color
        initiatorlbl.font = UIFont(name: "Avenir", size: 10)
        initiatorlbl.center = CGPointMake(217, 47)
        initiatorlbl.textAlignment = NSTextAlignment.Right
        initiatorlbl.text = "with " + rowActivity.initiator.name
        if (rowActivity.initiator.name != ""){
            cell.addSubview(initiatorlbl)
        }

        if (rowActivity.confirmedMembers.count > 0){
            let withOtherslbl = UILabel(frame: CGRectMake(0, 0, 200, 21))
            withOtherslbl.textColor = color
            withOtherslbl.font = UIFont(name: "Avenir", size: 10)
            withOtherslbl.center = CGPointMake(210, 60)
            withOtherslbl.textAlignment = NSTextAlignment.Right
            withOtherslbl.text = "and \(rowActivity.confirmedMembers.count) other(s)"
            cell.addSubview(withOtherslbl)
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Create instance of DetailViewController
        var detail:DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
 
        let row = activities[indexPath.row]
        detail.activity = row
        detail.user = self.user
        
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
}

