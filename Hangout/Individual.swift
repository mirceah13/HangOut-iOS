//
//  Individual.swift
//  Hangout
//
//  Created by Recognos on 16/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class Individual: Serializable {
    var name: NSString = ""
    var email: NSString = ""
    var profileUrl: NSString = ""
    var avatarImageUrl: NSString = ""
    
    override init(){
        super.init()
    }
    
    init(name:String, email:String, profileUrl:String){
        self.name = name;
        self.email = email;
        self.profileUrl = profileUrl
        self.avatarImageUrl = ""
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
        if let memberProfileUrl = JSONDict.valueForKey("avatarImageUrl") as? String{
            self.avatarImageUrl = memberProfileUrl
        }
    }
    
    func IS(me: Individual)->Bool{
        return me.email == self.email
    }
    
    func emailHash()->String{
        return (self.email as String).md5()
    }
    
    func gravatarProfileImageUrl(size:String)->String{
        return "http://www.gravatar.com/avatar/" + self.emailHash() + "?s=" + size
    }
    
    func friendlyName()->String{
        return self.name != "" ? self.name + "[" + self.email + "]" : self.email
    }
    
    func setAvatar(url:String){
        self.avatarImageUrl = url
    }
    
    func avatar(size:String)->String{
        if (self.avatarImageUrl == ""){
            return self.gravatarProfileImageUrl(size)
        }
        return self.avatarImageUrl
    }
}