//
//  Place.swift
//  Hangout
//
//  Created by Recognos on 16/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class Place: Serializable {
    var name:NSString = ""
    var address:NSString = ""
    var details:NSString = ""
    var websiteUrl:NSString = ""
    var logoUrl:NSString = ""
    var matchWeight:Int = 0
    var location:GpsLocation?
    var tags:NSArray = []
    
    class var unknown:Place {
        return Place(name: "", address: "", details: "", websiteUrl: "", logoUrl: "" , matchWeight: 0, location: GpsLocation.unknown)
    }
    
    init(name:String, address:String, details:String, websiteUrl:String, logoUrl:String, matchWeight:Int, location:GpsLocation){
        self.name = name
        self.address = address
        self.details = details
        self.websiteUrl = websiteUrl
        self.location = location
        self.logoUrl = logoUrl
        self.matchWeight = matchWeight
        self.tags = []
    }
}