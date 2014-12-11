//
//  AddActivityViewController.swift
//  Hangout
//
//  Created by Recognos on 09/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

    @IBOutlet var lblUserInfo: UILabel?
    @IBOutlet var imgUserInfo: UIImageView?
    @IBOutlet var lblCreateNew: UILabel?
    var user:Individual = Individual()
    
    @IBAction func btnCancel(){
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawLayout()
        self.drawLogin()
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func goToLanding(){
        let landingVC = self.storyboard?.instantiateViewControllerWithIdentifier("landingVC") as LandingViewController
        landingVC.user = self.user
        self.navigationController?.pushViewController(landingVC, animated: true)
    }
    
    func goToEditNewActivity(){
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("newVC") as NewActivityViewController
        newVC.user = self.user
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func drawLayout(){
        let bGround1 = CGRectMake(7, 184, 150, 16)
        var bView1:UIView = UIView(frame: bGround1)
        bView1.backgroundColor = UIColor.whiteColor()
        
        bView1.layer.shadowColor = UIColor.grayColor().CGColor
        bView1.layer.shadowOffset = CGSizeMake(0, 2);
        bView1.layer.shadowOpacity = 2;
        bView1.layer.shadowRadius = 2.0;
        bView1.clipsToBounds = false;
        
        let bGround2 = CGRectMake(165, 184, 150, 16)
        var bView2:UIView = UIView(frame: bGround2)
        bView2.backgroundColor = UIColor.whiteColor()
        
        bView2.layer.shadowColor = UIColor.grayColor().CGColor
        bView2.layer.shadowOffset = CGSizeMake(0, 2);
        bView2.layer.shadowOpacity = 2;
        bView2.layer.shadowRadius = 2.0;
        bView2.clipsToBounds = false;
        
        let bGround3 = CGRectMake(7, 334, 150, 16)
        var bView3:UIView = UIView(frame: bGround3)
        bView3.backgroundColor = UIColor.whiteColor()
        
        bView3.layer.shadowColor = UIColor.grayColor().CGColor
        bView3.layer.shadowOffset = CGSizeMake(0, 2);
        bView3.layer.shadowOpacity = 2;
        bView3.layer.shadowRadius = 2.0;
        bView3.clipsToBounds = false;
        
        let bGround4 = CGRectMake(165, 334, 150, 16)
        var bView4:UIView = UIView(frame: bGround4)
        bView4.backgroundColor = UIColor.whiteColor()
        
        bView4.layer.shadowColor = UIColor.grayColor().CGColor
        bView4.layer.shadowOffset = CGSizeMake(0, 2);
        bView4.layer.shadowOpacity = 2;
        bView4.layer.shadowRadius = 2.0;
        bView4.clipsToBounds = false;
        
        let bGround5 = CGRectMake(7, 483, 150, 16)
        var bView5:UIView = UIView(frame: bGround5)
        bView5.backgroundColor = UIColor.whiteColor()
        
        bView5.layer.shadowColor = UIColor.grayColor().CGColor
        bView5.layer.shadowOffset = CGSizeMake(0, 2);
        bView5.layer.shadowOpacity = 2;
        bView5.layer.shadowRadius = 2.0;
        bView5.clipsToBounds = false;
        
        let bGround6 = CGRectMake(165, 483, 150, 16)
        var bView6:UIView = UIView(frame: bGround6)
        bView6.backgroundColor = UIColor.whiteColor()
        
        bView6.layer.shadowColor = UIColor.grayColor().CGColor
        bView6.layer.shadowOffset = CGSizeMake(0, 2);
        bView6.layer.shadowOpacity = 2;
        bView6.layer.shadowRadius = 2.0;
        bView6.clipsToBounds = false;
        
        let bGround7 = CGRectMake(8, 515, 305, 32)
        var bView7:UIView = UIView(frame: bGround7)
        bView7.backgroundColor = UIColor.whiteColor()
        
        bView7.layer.shadowColor = UIColor.grayColor().CGColor
        bView7.layer.shadowOffset = CGSizeMake(0, 2);
        bView7.layer.shadowOpacity = 2;
        bView7.layer.shadowRadius = 2.0;
        bView7.clipsToBounds = false;

        self.view.addSubview(bView1)
        self.view.addSubview(bView2)
        self.view.addSubview(bView3)
        self.view.addSubview(bView4)
        self.view.addSubview(bView5)
        self.view.addSubview(bView6)
        self.view.addSubview(bView7)
        self.view.bringSubviewToFront(lblCreateNew!)
        
        let labelItems = [("Indoor",55, 183),("Outdoor",215, 183),("Water", 55 ,333), ("Mountain", 215 ,333),("Ballgames", 55, 482),("Social",215, 482)]
        for labelItem in labelItems {
            let x = labelItem.1 as Int
            let y = labelItem.2 as Int
            let label = UILabel(frame: CGRectMake(CGFloat(x), CGFloat(y), 60, 21))
            label.font = UIFont(name: "Avenir-Heavy", size: 11)
            label.text = labelItem.0 as NSString
            label.textColor = UIColor.grayColor()
            label.textAlignment = NSTextAlignment.Center
            
            self.view.addSubview(label);
        }
        
        let buttonItems = [("Indoor",7, 71),("Outdoor",165, 71),("Water", 7 ,220), ("Mountain", 165 ,220),("Ballgames", 7, 369),("Social",165, 369)]
        for buttonItem in buttonItems {
            let x = buttonItem.1 as Int
            let y = buttonItem.2 as Int
            let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
            button.frame = CGRectMake(CGFloat(x), CGFloat(y), 150, 132)
            button.addTarget(self, action: "goToEditNewActivity", forControlEvents:.TouchUpInside)
            
            self.view.addSubview(button);
        }
        
        let newButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        newButton.frame = CGRectMake(8, 515, 305, 32)
        newButton.addTarget(self, action: "goToEditNewActivity", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(newButton);


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
        xButton.addTarget(self, action: "goToLanding", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(bView0)
        self.view.sendSubviewToBack(bView0)
        self.view.addSubview(button)
        self.view.addSubview(xButton)
        self.view.bringSubviewToFront(xButton)
        
    }
    
    func logOut(){
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as LoginViewController
        loginVC.UserNameTextField?.text = ""
        loginVC.UserEmailTextField?.text = ""
        FBSession.activeSession().closeAndClearTokenInformation()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}
