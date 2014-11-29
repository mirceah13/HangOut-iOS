//
//  LandingViewController.swift
//  Hangout
//
//  Created by Recognos on 28/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    var userName:String = ""
    var userEmail:String = ""
    var userProfileImageUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initiateBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 170, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        initiateBtn.setTitle("INITIATE ACTIVITY", forState: UIControlState.Normal)
        
        let yourActivitiesBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 220, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        yourActivitiesBtn.setTitle("YOUR ACTIVITIES", forState: UIControlState.Normal)
        
        let joinableEventsBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 370, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        joinableEventsBtn.setTitle("EVENTS YOU MAI JOIN ", forState: UIControlState.Normal)
        
        let joinedEventsBtn: SFlatButton = SFlatButton(frame: CGRectMake(10, 420, 300, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDefault)
        joinedEventsBtn.setTitle("JOINED EVENTS", forState: UIControlState.Normal)

        
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
    
}
