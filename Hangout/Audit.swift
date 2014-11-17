//
//  Audit.swift
//  Hangout
//
//  Created by Recognos on 15/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class Audit: NSObject {
    var reason: String = ""
    var at: NSDate?
    var email: String

    init(reason: String, at:NSDate, email: String){
        self.reason = reason
        self.at = at
        self.email = email
    }
    
    init(JSONDict: NSDictionary){
        self.email = ""
        self.reason = ""
        self.at = NSDate(timeIntervalSinceNow: 0)
        if let auditReason = JSONDict.valueForKey("reason") as? String{
            self.reason = auditReason
        }
        if let auditEmail = JSONDict.valueForKey("email") as? String{
            self.email = auditEmail
        }
        if let auditAt = JSONDict.valueForKey("at") as? Double{
            self.at = NSDate(timeIntervalSince1970: auditAt / 1000)
        }

    }
}