//
//  Individual.swift
//  Hangout
//
//  Created by Recognos on 16/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class Individual: NSObject {
    var name: String = ""
    var email: String = ""
    var profileUrl: String? = ""
    
    init(name:String, email:String, profileUrl:String?){
        self.name = name;
        self.email = email;
        self.profileUrl = profileUrl
    }
    
    init(JSONDict: NSDictionary){
        self.name = ""
        self.email = ""
        self.profileUrl = ""
        let memberEntry:Individual = Individual(name: "", email: "", profileUrl: "")
        if let memberName = JSONDict.valueForKey("name") as? String{
            self.name = memberName
        }
        if let memberEmail = JSONDict.valueForKey("email") as? String{
            self.email = memberEmail
        }
        if let memberProfileUrl = JSONDict.valueForKey("profileUrl") as? String{
            self.profileUrl = memberProfileUrl
        }
    }
}