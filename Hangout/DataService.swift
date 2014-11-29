//
//  DS.swift
//  Hangout
//
//  Created by Recognos on 27/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class DataService: NSObject {
    
    var dataStore: DataStore = DataStore()
    
    class func currentDate()->NSDate{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        return date
    }
    
    func loadActivity(id: String){
        let activity: AnyObject = dataStore.Load(id)
        
    }
    
    func storeActivity(activity: Activity){
        var entity = DataStore.Entity(data: activity, meta: activity.meta())
        dataStore.Save(entity)
    }
    
    func persistUpdatedActivity(id: String, token: String, activity: Activity){
        var entity = DataStore.Entity(data: activity, meta: activity.meta())
        entity.id = id
        entity.checkTag = token
        
        dataStore.Save(entity)
    }
    
    func fetchJoinableActivities(user: Individual)->[Activity]{
        var params:[QueryParameter] = []
        params.push(QueryParameter(Name: "initiator", Operator: QueryParameterOperator.Equals, Value: user.email, Negated: true))
        params.push(QueryParameter(Name: "participants", Operator: QueryParameterOperator.Contains, Value: user.email, Negated: true))
        params.push(QueryParameter(Name: "startsOn", Operator: QueryParameterOperator.HigherThan, Value: Int(DataService.currentDate().timeIntervalSince1970 as Double)))
        params.push(QueryParameter(Name: "isCancelled", Operator: QueryParameterOperator.Equals, Value: "false"))
        params.push(QueryParameter(Name: "isWrapped", Operator: QueryParameterOperator.Equals, Value: "false"))
    
        var activities = dataStore.Query(ChainOperation.And, queryParams: params) as [Activity]

        
        return activities
    }
    
    func fetchActivitiesFor(user: Individual)->[Activity]{
        var params:[QueryParameter] = []
        params.push(QueryParameter(Name: "initiator", Operator: QueryParameterOperator.Equals, Value: user.email))
        params.push(QueryParameter(Name: "startsOn", Operator: QueryParameterOperator.HigherThan, Value: Int(DataService.currentDate().timeIntervalSince1970 as Double)))
        params.push(QueryParameter(Name: "isCancelled", Operator: QueryParameterOperator.Equals, Value: "false"))
        
        var activities = dataStore.Query(ChainOperation.And, queryParams: params) as [Activity]
        
        return activities
    }
    
    func fetchActivitiesForParticipant(user: Individual)->[Activity]{
        var params:[QueryParameter] = []
        params.push(QueryParameter(Name: "participants", Operator: QueryParameterOperator.Contains, Value: user.email))
        params.push(QueryParameter(Name: "startsOn", Operator: QueryParameterOperator.HigherThan, Value: Int(DataService.currentDate().timeIntervalSince1970 as Double)))
        params.push(QueryParameter(Name: "isCancelled", Operator: QueryParameterOperator.Equals, Value: "false"))
        
        var activities = dataStore.Query(ChainOperation.And, queryParams: params) as [Activity]
        
        return activities
    }
}
