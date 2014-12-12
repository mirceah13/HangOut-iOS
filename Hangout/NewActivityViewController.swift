//
//  NewActivityViewController.swift
//  Hangout
//
//  Created by Recognos on 11/12/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class NewActivityViewController: UIViewController {

    @IBOutlet var lblUserInfo: UILabel?
    @IBOutlet var imgUserInfo: UIImageView?
    @IBOutlet var lblPublish: UILabel?
    @IBOutlet var imgBackground: UIImageView?
    var user:Individual = Individual()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.drawLayout()
        self.drawLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    func goToInitiate(){
        let initiateVC = self.storyboard?.instantiateViewControllerWithIdentifier("initiateVC") as AddActivityViewController
        initiateVC.user = self.user
        self.navigationController?.pushViewController(initiateVC, animated: true)
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
        xButton.addTarget(self, action: "goToInitiate", forControlEvents:UIControlEvents.TouchUpInside)
        
        self.view.addSubview(bView0)
        self.view.sendSubviewToBack(bView0)
        self.view.addSubview(button)
        self.view.addSubview(xButton)
        self.view.bringSubviewToFront(xButton)
        
    }
    
    func drawLayout(){
        
        let bGround = CGRectMake(8, 500, 305, 32)
        var bView:UIView = UIView(frame: bGround)
        bView.backgroundColor = Utils.colorWithHexString("#EB3F3F")
        
        bView.layer.shadowColor = UIColor.grayColor().CGColor
        bView.layer.shadowOffset = CGSizeMake(0, 2);
        bView.layer.shadowOpacity = 2;
        bView.layer.shadowRadius = 2.0;
        bView.clipsToBounds = false;

        let newButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        newButton.frame = CGRectMake(8, 155, 305, 32)
        newButton.addTarget(self, action: "", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(bView)
        self.view.addSubview(newButton);
        self.view.bringSubviewToFront(newButton)
        self.view.sendSubviewToBack(imgBackground!)
        self.view.bringSubviewToFront(lblPublish!)
    }

}
