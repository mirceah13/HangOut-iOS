//
//  DetailViewController.swift
//  Hangout
//
//  Created by Recognos on 07/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit
import MapKit.MKMapView
import Social


class DetailViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {
    
    //Our label for displaying var "items/cellName"
    @IBOutlet var cellDetailLabel: UILabel!
    @IBOutlet var cellStartsOnLabel: UILabel!
    @IBOutlet weak var pendingMembersCollectionView: UICollectionView!
    @IBOutlet weak var confirmedMemersCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var lblUserInfo: UILabel?
    @IBOutlet var imgUserInfo: UIImageView?
    

    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    var activity:Activity = Activity()
    var user:Individual = Individual()
    var pendingLabel:UILabel = UILabel()
    var formater = NSDateFormatter()
    
    var pendingMembers:[Individual] = []
    var confirmedMembers:[Individual] = []

    var dangerbtn: SFlatButton = SFlatButton(frame: CGRectMake(60, 510, 200, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formater.dateFormat = "E d MMM hh:mm"
        
        var alreadyJoined:Bool = false;
        
        for member in self.activity.pendingMembers  {
            if member.email == self.user.email {
                alreadyJoined = true
                break
            }
        }
        for member in self.activity.confirmedMembers  {
            if member.email == self.user.email {
                alreadyJoined = true
                break
            }
        }
        if (alreadyJoined){
            dangerbtn.setTitle("Cancel my participation", forState: UIControlState.Normal)
            dangerbtn.addTarget(self, action: "promptBailoutReason", forControlEvents: .TouchUpInside)
        } else {
            dangerbtn.setTitle("I want to join this", forState: UIControlState.Normal)
            dangerbtn.addTarget(self, action: "joinActivity", forControlEvents: .TouchUpInside)
        }
        
        
        self.view.addSubview(dangerbtn)

        cellDetailLabel.text = "Initiated by " + activity.initiator.name as String
        if let startsOn = activity.startsOn{
            cellStartsOnLabel.text = "Happening on " + formater.stringFromDate(startsOn)
        }
        
        pendingMembers = self.activity.pendingMembers
        confirmedMembers = self.activity.confirmedMembers
        pendingMembers.push(self.activity.initiator)
        confirmedMembers.push(self.activity.initiator)
        
        //Assign String variable to NavBar title
        self.title = self.activity.title
        
        cellDetailLabel.numberOfLines = 0
        self.drawLayout()
        self.drawLogin()
        
        self.showMap()
        // Do any additional setup after loading the view.
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == confirmedMemersCollectionView{
            return confirmedMembers.count
        }
        if collectionView == pendingMembersCollectionView{
            return pendingMembers.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as CollectionViewCell
        
        cell.imgView.layer.shadowColor = UIColor.grayColor().CGColor
        cell.imgView.layer.shadowOffset = CGSizeMake(0, 2);
        cell.imgView.layer.shadowOpacity = 1;
        cell.imgView.layer.shadowRadius = 2.0;
        cell.imgView.clipsToBounds = false;
        
        if collectionView == confirmedMemersCollectionView{
            let member = confirmedMembers[indexPath.row] as Individual
            cell.userName?.text = member.name
            if (member.avatar("100") != ""){
                let url = NSURL(string: member.avatar("100"));
                var imageData:NSData = NSData(contentsOfURL: url!)!
                cell.imgView.image = UIImage(data: imageData)
            } else {
                cell.imgView.image = UIImage(named: "avatar-male.png")
            }
        }
        if collectionView == pendingMembersCollectionView{
            let member = pendingMembers[indexPath.row] as Individual
            cell.userName?.text = member.name
            if (member.avatar("100") != ""){
                let url = NSURL(string: member.avatar("100"));
                var imageData:NSData = NSData(contentsOfURL: url!)!
                cell.imgView.image = UIImage(data: imageData)
            } else {
                cell.imgView.image = UIImage(named: "avatar-male.png")
            }
        }
    
        return cell
    }

    func showMap(){
        var latitude:CLLocationDegrees = self.activity.place.location!.lat
        var longitude:CLLocationDegrees = self.activity.place.location!.lng
        
        var latDelta:CLLocationDegrees = 0.01
        var lngDelta:CLLocationDegrees = 0.01
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lngDelta)
        var activityLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(activityLocation, theSpan)
        
        self.mapView.setRegion(theRegion, animated: true)
    
        var activityLocationAnnotation = MKPointAnnotation()
        activityLocationAnnotation.coordinate =  activityLocation
        activityLocationAnnotation.title = self.activity.place.name
        activityLocationAnnotation.subtitle = self.activity.place.address
        
        self.mapView.addAnnotation(activityLocationAnnotation)
    }

    func joinActivity(){        
        persistenceHelper.joinActivity(self.activity, individual: self.user)
        if (!self.pendingMembers.contains(self.user)){
            self.pendingMembers.push(self.user)
            self.dangerbtn.setTitle("Cancel my participation", forState: UIControlState.Normal)
            self.dangerbtn.removeTarget(self, action: "joinActivity", forControlEvents: .TouchUpInside)
            self.dangerbtn.addTarget(self, action: "promptBailoutReason", forControlEvents: .TouchUpInside)

        }
        self.pendingMembersCollectionView.reloadData()
        let activityVC = self.storyboard?.instantiateViewControllerWithIdentifier("activityVC") as ActivityViewController
        activityVC.activities = persistenceHelper.list(self.user, type: ActivityScreenType.JoinableActivities) as [Activity]
        activityVC.activityTable?.reloadData()
        pendingLabel.text = "\(self.pendingMembers.count) willing participant(s)"
    }
    
    func leaveActivity(reason: String){
        persistenceHelper.leaveActivity(self.activity, individual: self.user, reason: reason)
        for member in self.pendingMembers  {
            if member.email == self.user.email {
                self.pendingMembers.remove(member)
                self.dangerbtn.setTitle("I want to join this", forState: UIControlState.Normal)
                self.dangerbtn.removeTarget(self, action: "promptBailoutReason", forControlEvents: .TouchUpInside)
                self.dangerbtn.addTarget(self, action: "joinActivity", forControlEvents: .TouchUpInside)
                self.pendingLabel.text = "\(self.pendingMembers.count) willing participant(s)"
                break
            }
        }
        
        self.pendingMembersCollectionView.reloadData()
        let activityVC = self.storyboard?.instantiateViewControllerWithIdentifier("activityVC") as ActivityViewController
        activityVC.activities = persistenceHelper.list(self.user, type: ActivityScreenType.JoinableActivities) as [Activity]
        activityVC.activityTable?.reloadData()
    }
    
    func promptBailoutReason(){
        let alertController: UIAlertController = UIAlertController(title: "Bail out", message: "Are you sure you want to bail out?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let changedMind = UIAlertAction(title: "I changed my mind", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.leaveActivity("I changed my mind")})
        let feel = UIAlertAction(title: "Just don't feel like it", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.leaveActivity("Just don't feel like it")})
        let plans = UIAlertAction(title: "Got better plans", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.leaveActivity("Got better plans")})
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(changedMind)
        alertController.addAction(feel)
        alertController.addAction(plans)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func goToChat(){
        let chatVC = self.storyboard?.instantiateViewControllerWithIdentifier("chatVC") as ChatViewController
        chatVC.activityId = self.activity.getId()
        chatVC.user = self.user
        chatVC.activity = self.activity
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func goToLanding(){
        let landingVC = self.storyboard?.instantiateViewControllerWithIdentifier("landingVC") as LandingViewController
        landingVC.user = self.user
        self.navigationController?.pushViewController(landingVC, animated: true)
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
    
    func shareToFacebook(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            controller.setInitialText("Want to hang out? http://hang-out-with.us/#!/activity/\(self.activity.getId())")
            controller.addImage(UIImage(named: "Branding_120x120.png"))
            self.presentViewController(controller, animated:true, completion:nil)
        }
        else {
            println("no Facebook account found on device")
        }
    }
    
    func shareToTwitter(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            var controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            controller.setInitialText("Want to hang out? http://hang-out-with.us/#!/activity/\(self.activity.getId())")
            controller.addImage(UIImage(named: "Branding_120x120.png"))
            self.presentViewController(controller, animated:true, completion:nil)
        }
        else {
            println("no Twitter account found on device")
        }
        
    }
    
    func shareToGooglePlus(){
        
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
        
        let facebookButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        facebookButton.frame = CGRectMake(9, 73, 45, 45)
        facebookButton.addTarget(self, action: "shareToFacebook", forControlEvents:.TouchUpInside)
        
        let twitterButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        twitterButton.frame = CGRectMake(81, 73, 45, 45)
        twitterButton.addTarget(self, action: "shareToTwitter", forControlEvents:.TouchUpInside)
        
        self.view.addSubview(bView0)
        self.view.sendSubviewToBack(bView0)
        self.view.addSubview(button)
        self.view.addSubview(xButton)
        self.view.addSubview(facebookButton)
        self.view.addSubview(twitterButton)
        self.view.bringSubviewToFront(xButton)
        self.view.bringSubviewToFront(facebookButton)
        self.view.bringSubviewToFront(twitterButton)
        
    }
    
    func drawLayout(){
        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(224, 73, 43, 43)
        button.addTarget(self, action: "goToChat", forControlEvents:.TouchUpInside)
        
        let bGround0 = CGRectMake(0, 121, self.view.bounds.width, 16)
        var bView0:UIView = UIView(frame: bGround0)
        bView0.backgroundColor = Utils.colorWithHexString("#EB3F3F")
        
        bView0.layer.shadowColor = UIColor.grayColor().CGColor
        bView0.layer.shadowOffset = CGSizeMake(0, 1);
        bView0.layer.shadowOpacity = 1;
        bView0.layer.shadowRadius = 1.0;
        bView0.clipsToBounds = false;
        
        let bGround1 = CGRectMake(0, 201, self.view.bounds.width, 16)
        var bView1:UIView = UIView(frame: bGround1)
        bView1.backgroundColor = UIColor.whiteColor()
        
        bView1.layer.shadowColor = UIColor.grayColor().CGColor
        bView1.layer.shadowOffset = CGSizeMake(0, 1);
        bView1.layer.shadowOpacity = 1;
        bView1.layer.shadowRadius = 1.0;
        bView1.clipsToBounds = false;
        
        let confirmedLabel = UILabel(frame: CGRectMake(5, 119, 200, 21))
        confirmedLabel.font = UIFont(name: "Avenir", size: 11)
        confirmedLabel.text = "\(self.confirmedMembers.count) confirmed participant(s)"
        confirmedLabel.textColor = UIColor.whiteColor()
        
        pendingLabel = UILabel(frame: CGRectMake(5, 199, 200, 21))
        pendingLabel.font = UIFont(name: "Avenir", size: 11)
        pendingLabel.text = "\(self.pendingMembers.count) willing participant(s)"
        pendingLabel.textColor = UIColor.grayColor()
        
        
        self.view.addSubview(bView0)
        self.view.addSubview(bView1)
        self.view.addSubview(confirmedLabel)
        self.view.addSubview(pendingLabel)
        self.view.addSubview(button)

    }
}
