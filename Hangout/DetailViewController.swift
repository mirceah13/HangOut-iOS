//
//  DetailViewController.swift
//  Hangout
//
//  Created by Recognos on 07/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit
import MapKit.MKMapView


class DetailViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {
    
    //Our label for displaying var "items/cellName"
    @IBOutlet var cellNameLabel: UILabel!
    @IBOutlet var cellDetailLabel: UILabel!
    @IBOutlet var cellStartsOnLabel: UILabel!
    @IBOutlet weak var pendingMembersCollectionView: UICollectionView!
    @IBOutlet weak var confirmedMemersCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    

    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    var activity:Activity = Activity()
    var user:Individual = Individual()
    var formater = NSDateFormatter()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formater.dateFormat = "E d MMM hh:mm"
        
        let dangerbtn: SFlatButton = SFlatButton(frame: CGRectMake(60, 500, 200, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        dangerbtn.setTitle("I want to join this", forState: UIControlState.Normal)
        dangerbtn.addTarget(self, action: "joinActivity", forControlEvents: .TouchUpInside)
        self.view.addSubview(dangerbtn)
    
        //Assign your UILabel textvto your String
        cellNameLabel.text = self.activity.title
        cellDetailLabel.text = "Initiated by " + activity.initiator.name as String
        if let startsOn = activity.startsOn{
            cellStartsOnLabel.text = "Happening on " + formater.stringFromDate(startsOn)
        }
        
        //Assign String variable to NavBar title
        self.title = self.activity.title
        
        cellDetailLabel.numberOfLines = 0
        
        let lineRect1 = CGRectMake(0, 200, self.view.bounds.width, 1)
        var lineView1:UIView = UIView(frame: lineRect1)
        lineView1.backgroundColor = UIColor.whiteColor()
        
        let lineRect2 = CGRectMake(0, 280, self.view.bounds.width, 1)
        var lineView2:UIView = UIView(frame: lineRect2)
        lineView2.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(lineView1)
        self.view.addSubview(lineView2)

        self.showMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == confirmedMemersCollectionView{
            return self.activity.confirmedMembers.count
        }
        if collectionView == pendingMembersCollectionView{
            return self.activity.pendingMembers.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as CollectionViewCell
        
        cell.imgView.layer.shadowColor = UIColor.whiteColor().CGColor
        cell.imgView.layer.shadowOffset = CGSizeMake(0, 2);
        cell.imgView.layer.shadowOpacity = 1;
        cell.imgView.layer.shadowRadius = 2.0;
        cell.imgView.clipsToBounds = false;
        
        if collectionView == confirmedMemersCollectionView{
            let member = self.activity.confirmedMembers[indexPath.row] as Individual
            cell.userName?.text = member.name
            if (member.avatarImageUrl != ""){
                let url = NSURL(string: member.avatarImageUrl);
                var imageData:NSData = NSData(contentsOfURL: url!)!
                cell.imgView.image = UIImage(data: imageData)
            } else {
                cell.imgView.image = UIImage(named: "avatar-male.png")
            }
        }
        if collectionView == pendingMembersCollectionView{
            let member = self.activity.pendingMembers[indexPath.row] as Individual
            cell.userName?.text = member.name
            if (member.avatarImageUrl != ""){
                let url = NSURL(string: member.avatarImageUrl);
                var imageData:NSData = NSData(contentsOfURL: url!)!
                cell.imgView.image = UIImage(data: imageData)
            } else {
                cell.imgView.image = UIImage(named: "avatar-male.png")
            }
        }
    
        return cell
    }

    func showMap(){
        var latitude:CLLocationDegrees = self.activity.place.location!.lat!
        var longitude:CLLocationDegrees = self.activity.place.location!.lng!
        
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
    }
}
