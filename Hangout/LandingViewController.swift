//
//  LandingViewController.swift
//  Hangout
//
//  Created by Recognos on 28/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet var lblUserInfo: UILabel?
    @IBOutlet var imgUserInfo: UIImageView?
    var userName:String = ""
    var userEmail:String = ""
    var userProfileImageUrl:String = ""
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initiateBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 270, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        initiateBtn.setTitle("INITIATE ACTIVITY", forState: UIControlState.Normal)
        
        let yourActivitiesBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 320, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        yourActivitiesBtn.setTitle("YOUR ACTIVITIES", forState: UIControlState.Normal)
        
        let joinableEventsBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 400, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        joinableEventsBtn.setTitle("EVENTS YOU MAI JOIN ", forState: UIControlState.Normal)
        
        let joinedEventsBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 450, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        joinedEventsBtn.setTitle("JOINED EVENTS", forState: UIControlState.Normal)
        lblUserInfo?.text = self.userName
        let url = NSURL(string: self.userProfileImageUrl);
        var imageData:NSData = NSData(contentsOfURL: url!)!
        imgUserInfo?.image = UIImage(data: imageData)
        
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(270, 45, 39, 39)
        button.addTarget(self, action: "promptLogout", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(button)

        
        initiateBtn.addTarget(self, action: "goToInitiate", forControlEvents: .TouchUpInside)
        joinableEventsBtn.addTarget(self, action: "goToJoinable", forControlEvents: .TouchUpInside)
        joinedEventsBtn.addTarget(self, action: "goToJoined", forControlEvents: .TouchUpInside)
        yourActivitiesBtn.addTarget(self, action: "goToMyActivities", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(initiateBtn)
        self.view.addSubview(joinableEventsBtn)
        self.view.addSubview(yourActivitiesBtn)
        self.view.addSubview(joinedEventsBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToJoinable(){
        let activityVC = fillActivityController()
        activityVC.screenType = ActivityScreenType.JoinableActivities
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
    func goToJoined(){
        let activityVC = fillActivityController()
        activityVC.screenType = ActivityScreenType.JoinedActivities
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
    func goToMyActivities(){
        let activityVC = fillActivityController()
        activityVC.screenType = ActivityScreenType.YourActitivies
        self.navigationController?.pushViewController(activityVC, animated: true)
    }
    
    func goToInitiate(){
        let initiateVC = self.storyboard?.instantiateViewControllerWithIdentifier("initiateVC") as ActivityViewController
        self.navigationController?.pushViewController(initiateVC, animated: true)
    }
    
    func fillActivityController()->ActivityViewController{
        let activityVC = self.storyboard?.instantiateViewControllerWithIdentifier("activityVC") as ActivityViewController
        activityVC.userName = self.userName
        activityVC.userEmail = self.userEmail
    
        return activityVC
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
    
}
