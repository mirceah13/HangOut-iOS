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
    @IBOutlet weak var lblError: UILabel!
    var landed:Bool = false
    var profileImageUrl:String = ""
    var landingVC = LandingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        landingVC = self.storyboard?.instantiateViewControllerWithIdentifier("landingVC") as LandingViewController
        
        self.UserEmailTextField.backgroundColor = UIColor(red: 10, green: 10, blue: 10, alpha: 0.1)
        self.UserNameTextField.backgroundColor = UIColor(red: 10, green: 10, blue: 10, alpha: 0.1)
        
        self.drawLayout()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.landed = false
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
    
    /// Facebook  Delegate Methods
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
        self.goToLanding()
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func goToLanding(){
        if (!landed){
            landed = true
        }
        else {
            return;
        }
        
        if (UserNameTextField?.text == "" || UserEmailTextField?.text == ""){
            lblError.text = "Are you sure this is you? You haven't filled in the fields 🚫"
            landed = false
            return
        }
        if (!Utils.isValidEmail(UserEmailTextField.text)){
            lblError.text = "That cannot possibly be a valid email address 🚫"
            landed = false
            return
        }
        
        landingVC.user.name = UserNameTextField.text
        landingVC.user.email = UserEmailTextField.text
        landingVC.user.avatarImageUrl = self.profileImageUrl
        
        self.navigationController?.pushViewController(landingVC, animated: true)
    }
    
    func drawLayout(){
        let dangerbtn: SFlatButton = SFlatButton(frame: CGRectMake(60, 450, 200, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        dangerbtn.setTitle("YUP, THAT'S ME", forState: UIControlState.Normal)
        dangerbtn.addTarget(self, action: "goToLanding", forControlEvents: .TouchUpInside)
        self.view.addSubview(dangerbtn)
    }

}
