//
//  LoginViewController.swift
//  Hangout
//
//  Created by Yosemite Retail on 11/19/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet var UserEmailTextField: UITextField!
    @IBOutlet var UserNameTextField: UITextField!
    @IBOutlet var fbLoginView: FBLoginView!
    
    var profileImageUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        let dangerbtn: SFlatButton = SFlatButton(frame: CGRectMake(60, 450, 200, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        dangerbtn.setTitle("YUP, THAT'S ME", forState: UIControlState.Normal)
        dangerbtn.addTarget(self, action: "goToLanding", forControlEvents: .TouchUpInside)
        self.view.addSubview(dangerbtn)
        
        self.UserEmailTextField.backgroundColor = UIColor(red: 10, green: 10, blue: 10, alpha: 0.1)
        self.UserNameTextField.backgroundColor = UIColor(red: 10, green: 10, blue: 10, alpha: 0.1)
        
    }
    
    //Facebook  Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser) {
        UserEmailTextField.text = user.objectForKey("email") as NSString
        UserNameTextField.text = user.name
        self.profileImageUrl = "https://graph.facebook.com/\(user.objectID)/picture?type=normal"
        
        self.goToLanding()
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
    }
    
    func loginView(loginView: FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    func goToLanding(){
        var landingVC = self.storyboard?.instantiateViewControllerWithIdentifier("landingVC") as LandingViewController

        landingVC.userName = UserNameTextField.text
        landingVC.userEmail = UserEmailTextField.text
        landingVC.userProfileImageUrl = self.profileImageUrl
        
        self.navigationController?.pushViewController(landingVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
