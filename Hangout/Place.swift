//
//  Place.swift
//  Hangout
//
//  Created by Recognos on 16/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class Place: NSObject {
    var name:String = ""
    var address:String = ""
    var details:String = ""
    var websiteUrl:String? = ""
    var location:GpsLocation = GpsLocation(lat: 0,lng: 0)
    var tags:NSArray = []
    
    class var unknown:Place {
        return Place(name: "", address: "", details: "", websiteUrl: "", location: GpsLocation.unknown)
    }
    
    init(name:String, address:String, details:String, websiteUrl:String?, location:GpsLocation){
        self.name = name
        self.address = address
        self.details = details
        self.websiteUrl = websiteUrl
        self.location = location
        self.tags = []
    }
}