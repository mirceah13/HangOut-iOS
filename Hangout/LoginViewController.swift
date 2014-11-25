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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        let dangerbtn: SFlatButton = SFlatButton(frame: CGRectMake(60, 330, 200, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        dangerbtn.setTitle("YUP, THAT'S ME", forState: UIControlState.Normal)
        dangerbtn.addTarget(self, action: "goToMain", forControlEvents: .TouchUpInside)
        self.view.addSubview(dangerbtn)
        
        
    }
    
    //Facebook  Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser) {
        UserEmailTextField.text = user.objectForKey("email") as NSString
        UserNameTextField.text = user.name
        self.goToMain()
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
    }
    
    func loginView(loginView: FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    func goToMain(){
        let mainVC = self.storyboard?.instantiateViewControllerWithIdentifier("mainVC") as ViewController

        
        mainVC.userEmail = UserEmailTextField.text
        mainVC.userName = UserNameTextField.text
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
