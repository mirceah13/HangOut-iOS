//
//  Activity1.swift
//  Hangout
//
//  Created by Recognos on 14/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class Activity: Serializable{
    var id: NSString = ""
    var checkTag: NSString = ""
    var initiator:Individual = Individual()
    var pendingMembers:[Individual] = []
    var confirmedMembers:[Individual] = []
    var title:NSString = ""
    var desc:NSString = ""
    var startsOn:NSDate?
    var endsOn:NSDate?
    var isWrapped:Bool = false
    var isCancelled:Bool = false
    var cancellationReason:NSString = ""
    var bailAudit:[Audit] = []
    var unWrapAudit:[Audit] = []
    var tags:NSArray = []
    var place:Place = Place.unknown
    
    override init(){
        super.init()
    }
    
    init(initiator:Individual, title:String, startsOn:NSDate, endsOn:NSDate, place:Place, description:String){
        self.initiator = initiator
        self.title = title
        self.startsOn = startsOn
        self.endsOn = endsOn
        self.place = place
        self.desc = description
    }
    
    init(JSONString: String){
        var null:NSNull
        let cleanQuotes = JSONString.stringByReplacingOccurrencesOfString("\\\"", withString: "<mToKm>", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let cleanedv1 = cleanQuotes.stringByReplacingOccurrencesOfString("\\\"", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let cleaned = cleanedv1.stringByReplacingOccurrencesOfString("\"\"}", withString: "\"}", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let cleanedFinal = cleaned.stringByReplacingOccurrencesOfString("<mToKm>", withString: "\\\"", options: NSStringCompareOptions.LiteralSearch, range: nil) as NSString!
        var JSONdata = (cleanedFinal).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) as NSData?
        let parser = JSONParser(JSONdata)
        
        if let id = parser.get("Id") as? String{
            self.id = id
        }
        if let checkTag = parser.get("CheckTag") as? String{
            self.checkTag = checkTag
        }
        if let startsOn = parser.get("Data.startsOn") as? Double{
            self.startsOn = NSDate(timeIntervalSince1970: startsOn / 1000)
        }
        if let endsOn = parser.get("Data.endsOn") as? Double{
            self.endsOn = NSDate(timeIntervalSince1970: endsOn / 1000)
        }
        if let description = parser.get("Data.description") as? String{
            self.desc = description
        }
        if let title = parser.get("Data.title") as? String{
            self.title = title
        }
        if let cancellationReason = parser.get("Data.cancellationReason") as? String{
            self.cancellationReason = cancellationReason
        }
        if let isCancelled = parser.get("Data.isCancelled") as? Bool{
            self.isCancelled = isCancelled
        }
        if let isWrapped = parser.get("Data.isWrapped") as? Bool{
            self.isWrapped = isWrapped
        }
        self.initiator = Individual(name: "", email: "", profileUrl: "")
        if let initiatorName = parser.get("Data.initiator.name") as? String{
            self.initiator.name = initiatorName
        }
        if let initiatorEmail = parser.get("Data.initiator.email") as? String{
            self.initiator.email = initiatorEmail
        }
        if let initiatorProfileUrl = parser.get("Data.initiator.profileUrl") as? String{
            self.initiator.profileUrl = initiatorProfileUrl
        }
        self.place = Place(name: "", address: "", details: "", websiteUrl: "", location: GpsLocation.unknown)
        if let placeName = parser.get("Data.place.name") as? String{
            self.place.name = placeName
        }
        if let placeAddress = parser.get("Data.place.address") as? String{
            self.place.address = placeAddress
        }
        if let placeWebsiteUrl = parser.get("Data.place.websiteUrl") as? String{
            self.place.websiteUrl = placeWebsiteUrl
        }
        if let placeTags = parser.getArray("Data.place.tags"){
            self.place.tags = placeTags
        }
        if let placeLocationLat = parser.get("Data.place.location.lat") as? Double{
            self.place.location?.lat = placeLocationLat
        }
        if let placeLocationLng = parser.get("Data.place.location.lng") as? Double{
            self.place.location?.lng = placeLocationLng
        }
        if let tags = parser.getArray("Data.tags"){
            self.tags = tags
        }
        if let bailAudit = parser.get("Data.bailAudit") as? NSArray{
            for item in bailAudit{
                let audit = item as NSDictionary
                let auditEntry:Audit = Audit(JSONDict: audit)
                self.bailAudit.push(auditEntry)
            }
        }
        
        if let unWrapAudit = parser.get("Data.unWrapAudit") as? NSArray{
            for item in unWrapAudit{
                let audit = item as NSDictionary
                let auditEntry:Audit = Audit(JSONDict: audit)                
                self.unWrapAudit.push(auditEntry)
            }
        }
        
        if let pendingMembers = parser.get("Data.pendingMembers") as? NSArray{
            for item in pendingMembers{
                let member = item as NSDictionary
                let memberEntry:Individual = Individual(JSONDict: member)
                self.pendingMembers.push(memberEntry)
            }
        }
        
        if let confirmedMembers = parser.get("Data.confirmedMembers") as? NSArray{
            for item in confirmedMembers{
                let member = item as NSDictionary
                let memberEntry:Individual = Individual(JSONDict: member)
                self.confirmedMembers.push(memberEntry)
            }
        }
    }
    
    func friendlyStatus() -> String{
        if(self.isCancelled){
            return "Cancelled, quoting:'" + self.cancellationReason + "'"
        }
        if(self.isWrapped){
            return "Confirmed"
        }
        return "Still pending"
    }
    
    func allParticipants() -> [Individual]{
        self.pendingMembers.append(self.initiator)
        return self.pendingMembers
    }
    
    func unconfirmedParticipants() -> [Individual]{
        return self.pendingMembers.difference(self.confirmedMembers)
    }
    
    func hasParticipant(individual: Individual) -> Bool{
        return self.allParticipants().any{$0.email == individual.email}
    }
    
    func isParticipantConfirmed(member: Individual) -> Bool{
        if (member.email == self.initiator.email){
            return true
        }
        
        return self.confirmedMembers.any{$0.email == member.email}
    }
    
    func joinMember(member: Individual){
        if (self.hasParticipant(member) || self.isWrapped){
            return;
        }
        self.pendingMembers.push(member)
    }
    
    func confirmMember(member: Individual){
        if (!self.hasParticipant(member)){
            //new Error 'This member is not willing to join this activity'
        }
        if (self.isParticipantConfirmed(member)){
            return;
        }
        var memberToConfirm = self.pendingMembers.filter{$0.email == member.email}.first
        self.confirmedMembers.push(memberToConfirm!)
    }
    
    func wrap(){
        self.isWrapped = true
    }
    
    func unWrap(reason:String){
        if (reason.isEmpty){
            //new Error 'A reason for unwrapping an activity must be provided'
        }
        //TODO Create audit class
        //self.unWrapAudit.push({at: NSDate(), reason: reason})
        self.isWrapped = false;
    }
    
    func cancel(reason:String){
        self.isCancelled = true
        self.cancellationReason = reason
    }
    
    func bailOut(member: Individual, reason: String){
        if (!self.hasParticipant(member)){
            return;
        }
        //self.bailAudit.push({at:NSDate(), email: member.email, reason: reason})
        if(self.isParticipantConfirmed(member) && self.isWrapped){
            self.unWrap(member.email + " who was a confirmed participant, bailed out, quoting:'" + reason + "'")
        }
        self.pendingMembers.remove(self.pendingMembers.filter{$0.email == member.email}.first!)
        self.confirmedMembers.remove(self.pendingMembers.filter{$0.email == member.email}.first!)
    }
    
    func meta() -> Meta{
        return Meta(activity: self)
    }
}