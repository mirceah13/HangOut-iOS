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
    
    var user:Individual = Individual()
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveAuthUser()
        self.drawLayout()
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
        let initiateVC = self.storyboard?.instantiateViewControllerWithIdentifier("initiateVC") as AddActivityViewController
        initiateVC.user = self.user
        self.navigationController?.pushViewController(initiateVC, animated: true)
    }
    
    func fillActivityController()->ActivityViewController{
        let activityVC = self.storyboard?.instantiateViewControllerWithIdentifier("activityVC") as ActivityViewController
        activityVC.user = self.user
    
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
        xButton.addTarget(self, action: "logOut", forControlEvents:.AllEvents)
        
        self.view.addSubview(bView0)
        self.view.sendSubviewToBack(bView0)
        self.view.addSubview(button)
        self.view.addSubview(xButton)
        self.view.bringSubviewToFront(xButton)

    }
    
    func drawLayout(){
        let initiateBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 270, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        initiateBtn.setTitle("INITIATE ACTIVITY", forState: UIControlState.Normal)
        
        let yourActivitiesBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 320, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        yourActivitiesBtn.setTitle("YOUR ACTIVITIES", forState: UIControlState.Normal)
        
        let joinableEventsBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 400, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        joinableEventsBtn.setTitle("ACTIVITIES YOU MAY JOIN ", forState: UIControlState.Normal)
        
        let joinedEventsBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 450, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        joinedEventsBtn.setTitle("JOINED EVENTS", forState: UIControlState.Normal)
        
        self.drawLogin()
        
        initiateBtn.addTarget(self, action: "goToInitiate", forControlEvents: .TouchUpInside)
        joinableEventsBtn.addTarget(self, action: "goToJoinable", forControlEvents: .TouchUpInside)
        joinedEventsBtn.addTarget(self, action: "goToJoined", forControlEvents: .TouchUpInside)
        yourActivitiesBtn.addTarget(self, action: "goToMyActivities", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(initiateBtn)
        self.view.addSubview(joinableEventsBtn)
        self.view.addSubview(yourActivitiesBtn)
        self.view.addSubview(joinedEventsBtn)
    }
    
    func logOut(){
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as LoginViewController
        loginVC.UserNameTextField?.text = ""
        loginVC.UserEmailTextField?.text = ""
        FBSession.activeSession().closeAndClearTokenInformation()
        self.navigationController?.pushViewController(loginVC, animated: true)
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
    
}
