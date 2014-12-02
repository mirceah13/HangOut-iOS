//
//  Meta.swift
//  Hangout
//
//  Created by Recognos on 16/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class Meta: Serializable {
    var initiator:NSString = ""
    var participants:NSString = ""
    var confirmedParticipants:NSString = ""
    var title:NSString = ""
    var startsOn:NSDate?
    var endsOn:NSDate?
    var isWrapped:Bool = false
    var isCancelled:Bool = false
    var placeName:NSString = ""
    var placeAddress:NSString = ""
    var placeLocationLat:Double = 0
    var placeLocationLng:Double = 0
    
    init(activity:Activity){
        self.initiator = activity.initiator.email
        //self.participants = ",".join(activity.pendingMembers.map{ $0.email }) as NSString
        //self.confirmedParticipants = ",".join(activity.confirmedMembers.map{ $0.email }) as NSString
        self.title = activity.title
        self.startsOn = activity.startsOn
        self.endsOn = activity.endsOn
        self.isWrapped = activity.isWrapped
        self.isCancelled = activity.isCancelled
        self.placeName = activity.place.name
        self.placeAddress = activity.place.address
        self.placeLocationLat = activity.place.location!.lat!
        self.placeLocationLng = activity.place.location!.lng!
    }
}
