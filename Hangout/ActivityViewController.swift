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
    @IBOutlet var lblUserInfo: UILabel?
    @IBOutlet var imgUserInfo: UIImageView?
    var user:Individual = Individual()
    var screenType:ActivityScreenType = ActivityScreenType.JoinableActivities
    var formater = NSDateFormatter()
    var activities:[Activity] = []
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawLogin()
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
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
        initiatorlbl.center = CGPointMake(217, 45)
        initiatorlbl.textAlignment = NSTextAlignment.Right
        initiatorlbl.text = "with " + rowActivity.initiator.name
        if (rowActivity.initiator.name != ""){
            cell.addSubview(initiatorlbl)
        }

        if (rowActivity.confirmedMembers.count > 0){
            let withOtherslbl = UILabel(frame: CGRectMake(0, 0, 200, 21))
            withOtherslbl.textColor = color
            withOtherslbl.font = UIFont(name: "Avenir", size: 10)
            withOtherslbl.center = CGPointMake(210, 58)
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
    
    func promptLogout(){
        let alertController: UIAlertController = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.logOut()})
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func logOut(){
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as LoginViewController
        loginVC.UserNameTextField?.text = ""
        loginVC.UserEmailTextField?.text = ""
        FBSession.activeSession().closeAndClearTokenInformation()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func goToLanding(){
        let landingVC = self.storyboard?.instantiateViewControllerWithIdentifier("landingVC") as LandingViewController
        landingVC.user = self.user
        self.navigationController?.pushViewController(landingVC, animated: true)
    }
    
    func drawLogin(){
        lblUserInfo?.text = self.user.name
        let url = NSURL(string: self.user.avatarImageUrl);
        if (self.user.avatarImageUrl as String != ""){
            var imageData:NSData = NSData(contentsOfURL: url!)!
            imgUserInfo?.image = UIImage(data: imageData)
        }
        else{
            imgUserInfo?.image = UIImage(named: "avatar-male.png")
        }
        
        imgUserInfo?.layer.shadowColor = UIColor.grayColor().CGColor
        imgUserInfo?.layer.shadowOffset = CGSizeMake(0, 3);
        imgUserInfo?.layer.shadowOpacity = 1;
        imgUserInfo?.layer.shadowRadius = 3.0;
        imgUserInfo?.clipsToBounds = false;
        
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(270, 45, 39, 45
        )
        button.addTarget(self, action: "promptLogout", forControlEvents:.TouchUpInside)
        
        let bGround0 = CGRectMake(0, 0, self.view.bounds.width, 60)
        var bView0:UIView = UIView(frame: bGround0)
        bView0.backgroundColor = Utils.colorWithHexString("#EB3F3F")
        
        bView0.layer.shadowColor = UIColor.grayColor().CGColor
        bView0.layer.shadowOffset = CGSizeMake(0, 1);
        bView0.layer.shadowOpacity = 1;
        bView0.layer.shadowRadius = 1.0;
        bView0.clipsToBounds = false;
        
        let xButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        xButton.frame = CGRectMake(10, 29, 65, 35)
        xButton.addTarget(self, action: "goToLanding", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(bView0)
        self.view.sendSubviewToBack(bView0)
        self.view.addSubview(button)
        self.view.addSubview(xButton)
        self.view.bringSubviewToFront(xButton)
    }

}

