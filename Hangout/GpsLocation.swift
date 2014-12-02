//
//  GpsLocation.swift
//  Hangout
//
//  Created by Recognos on 14/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class GpsLocation: Serializable {
    var lat: Double?
    var lng: Double?
    
    class var unknown:GpsLocation { return GpsLocation(lat:0, lng: 0)}
    
    init(lat:Double, lng:Double){
        self.lat = lat
        self.lng = lng
    }
    
    init(JSONForm: AnyObject){
        
    }
}

