//
//  AddActivityViewController.swift
//  Hangout
//
//  Created by Recognos on 09/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

    var categArr:[String] = []
    var user:Individual = Individual()
    
    @IBAction func btnCancel(){
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add new"
        
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
    
    func drawLayout(){
        
        let fGround = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        var fView:UIView = UIView(frame: fGround)
        fView.backgroundColor = Utils.colorWithHexString("#EB3F3F")
        
        let bGround0 = CGRectMake(0, 32, self.view.bounds.width, 16)
        var bView0:UIView = UIView(frame: bGround0)
        bView0.backgroundColor = UIColor.whiteColor()
        
        bView0.layer.shadowColor = UIColor.grayColor().CGColor
        bView0.layer.shadowOffset = CGSizeMake(0, 2);
        bView0.layer.shadowOpacity = 2;
        bView0.layer.shadowRadius = 2.0;
        bView0.clipsToBounds = false;
        
        let bGround1 = CGRectMake(0, 113, self.view.bounds.width, 16)
        var bView1:UIView = UIView(frame: bGround1)
        bView1.backgroundColor = UIColor.whiteColor()
        
        bView1.layer.shadowColor = UIColor.grayColor().CGColor
        bView1.layer.shadowOffset = CGSizeMake(0, 2);
        bView1.layer.shadowOpacity = 2;
        bView1.layer.shadowRadius = 2.0;
        bView1.clipsToBounds = false;
        
        let bGround2 = CGRectMake(0, 193, self.view.bounds.width, 16)
        var bView2:UIView = UIView(frame: bGround2)
        bView2.backgroundColor = UIColor.whiteColor()
        
        bView2.layer.shadowColor = UIColor.grayColor().CGColor
        bView2.layer.shadowOffset = CGSizeMake(0, 2);
        bView2.layer.shadowOpacity = 2;
        bView2.layer.shadowRadius = 2.0;
        bView2.clipsToBounds = false;
        
        let bGround3 = CGRectMake(0, 273, self.view.bounds.width, 16)
        var bView3:UIView = UIView(frame: bGround3)
        bView3.backgroundColor = UIColor.whiteColor()
        
        bView3.layer.shadowColor = UIColor.grayColor().CGColor
        bView3.layer.shadowOffset = CGSizeMake(0, 2);
        bView3.layer.shadowOpacity = 2;
        bView3.layer.shadowRadius = 2.0;
        bView3.clipsToBounds = false;
        
        let bGround4 = CGRectMake(0, 352, self.view.bounds.width, 16)
        var bView4:UIView = UIView(frame: bGround4)
        bView4.backgroundColor = UIColor.whiteColor()
        
        bView4.layer.shadowColor = UIColor.grayColor().CGColor
        bView4.layer.shadowOffset = CGSizeMake(0, 2);
        bView4.layer.shadowOpacity = 2;
        bView4.layer.shadowRadius = 2.0;
        bView4.clipsToBounds = false;
        
        let bGround5 = CGRectMake(0, 431, self.view.bounds.width, 16)
        var bView5:UIView = UIView(frame: bGround5)
        bView5.backgroundColor = UIColor.whiteColor()
        
        bView5.layer.shadowColor = UIColor.grayColor().CGColor
        bView5.layer.shadowOffset = CGSizeMake(0, 2);
        bView5.layer.shadowOpacity = 2;
        bView5.layer.shadowRadius = 2.0;
        bView5.clipsToBounds = false;
        
        let bGround6 = CGRectMake(0, 509, self.view.bounds.width, 16)
        var bView6:UIView = UIView(frame: bGround6)
        bView6.backgroundColor = UIColor.whiteColor()
        
        bView6.layer.shadowColor = UIColor.grayColor().CGColor
        bView6.layer.shadowOffset = CGSizeMake(0, 2);
        bView6.layer.shadowOpacity = 2;
        bView6.layer.shadowRadius = 2.0;
        bView6.clipsToBounds = false;
        
        let bGroundClose = CGRectMake(0, 525, 43, 43)
        var bViewClose:UIView = UIView(frame: bGroundClose)
        bViewClose.backgroundColor = UIColor.grayColor()
        
        let buttonClose = UIButton.buttonWithType(UIButtonType.System) as UIButton
        buttonClose.frame = CGRectMake(12, 532, 42, 28)
        buttonClose.addTarget(self, action: "goToLanding", forControlEvents:.TouchUpInside)


        self.view.addSubview(fView)
        self.view.addSubview(bView0)
        self.view.addSubview(bView1)
        self.view.addSubview(bView2)
        self.view.addSubview(bView3)
        self.view.addSubview(bView4)
        self.view.addSubview(bView5)
        self.view.addSubview(bView6)
        self.view.addSubview(bViewClose)
        self.view.addSubview(buttonClose)
        self.view.sendSubviewToBack(bViewClose)
        self.view.sendSubviewToBack(fView)
        
        let labelItems = [("Indoor",112),("Outdoor",192),("Mountain",272),("Water",351),("Ballgames",429),("Social",508)]
        for labelItem in labelItems {
            let yx = labelItem.1 as Int
            let label = UILabel(frame: CGRectMake(0, CGFloat(yx), 320, 21))
            label.font = UIFont(name: "Avenir-Heavy", size: 11)
            label.text = labelItem.0 as NSString
            label.textColor = UIColor.grayColor()
            label.textAlignment = NSTextAlignment.Center
            
            self.view.addSubview(label);
        }

    }
}
