//
//  DetailViewController.swift
//  Hangout
//
//  Created by Recognos on 07/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit
import MapKit.MKMapView


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {
    
    //Our label for displaying var "items/cellName"
    @IBOutlet var cellNameLabel: UILabel!
    @IBOutlet var cellDetailLabel: UILabel!
    @IBOutlet var cellStartsOnLabel: UILabel!
    @IBOutlet var confirmedMembersTableView: UITableView!
    @IBOutlet var pendingMembersTableView: UITableView!
    @IBOutlet weak var pendingMembersCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var confirmedMemersCollectionView: UICollectionView!
    //Receiving variable assigned to out MainViewController's var "activityItems"
    var cellName:String = ""
    var cellDesc:String = ""
    var cellStartsOn: String = ""
    var confirmedMembers: [Individual] = []
    var pendingMembers: [Individual] = []
    var locationLat: Double?
    var locationLng: Double?
    var place: Place = Place.unknown

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dangerbtn: SFlatButton = SFlatButton(frame: CGRectMake(60, 500, 200, 40), sfButtonType: SFlatButton.SFlatButtonType.SFBDanger)
        dangerbtn.setTitle("I want to join this", forState: UIControlState.Normal)
        self.view.addSubview(dangerbtn)
    
        //Assign your UILabel textvto your String
        cellNameLabel.text = cellName
        cellDetailLabel.text = cellDesc
        cellStartsOnLabel.text = cellStartsOn
        
        //Assign String variable to NavBar title
        self.title = cellName
        
        cellDetailLabel.numberOfLines = 0

        self.showMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == confirmedMembersTableView{
            return self.confirmedMembers.count
        }
        if tableView == pendingMembersTableView{
            return self.pendingMembers.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MembersTableView")!
        if tableView == confirmedMembersTableView{
            //Assigning content of the var "activityItems" to  the textLabel of each cell
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 11)
            cell.textLabel?.text = self.confirmedMembers[indexPath.row].name + " [" + self.confirmedMembers[indexPath.row].email  + "]"
        }
        
        if tableView == pendingMembersTableView{
            //Assigning content of the var "activityItems" to  the textLabel of each cell
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 11)
            cell.textLabel?.text = self.pendingMembers[indexPath.row].name + " [" + self.pendingMembers[indexPath.row].email  + "]"
        }
        cell.textLabel?.textColor = UIColor.grayColor()
        
        return cell;
    }

    func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        var label : UILabel = UILabel()
        if tableView == pendingMembersTableView{
            label.font = UIFont(name: "Helvetica-Bold", size: 12)
            label.text = "Pending Members"
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.redColor()
        }
        if tableView == confirmedMembersTableView{
            label.font = UIFont(name: "Helvetica-Bold", size: 12)
            label.text = "Confirmed Members"
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.redColor()
        }
        return label
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == confirmedMemersCollectionView{
            return self.confirmedMembers.count
        }
        if collectionView == pendingMembersCollectionView{
            return self.pendingMembers.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell =  collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as CollectionViewCell
        cell.imgView.image = UIImage(named: "avatar-male.png")
        return cell
    }

    func showMap(){
        var latitude:CLLocationDegrees = self.place.location!.lat!
        var longitude:CLLocationDegrees = self.place.location!.lng!
        
        var latDelta:CLLocationDegrees = 0.01
        var lngDelta:CLLocationDegrees = 0.01
        
        var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lngDelta)
        var activityLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(activityLocation, theSpan)
        
        self.mapView.setRegion(theRegion, animated: true)
    
        var activityLocationAnnotation = MKPointAnnotation()
        activityLocationAnnotation.coordinate =  activityLocation
        activityLocationAnnotation.title = self.place.name
        activityLocationAnnotation.subtitle = self.place.address
        
        self.mapView.addAnnotation(activityLocationAnnotation)
    }

}
