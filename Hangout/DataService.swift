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
    
    func loadActivity(id: String) -> Activity{
        let activity: Activity = dataStore.Load(id) as Activity
        return activity
        
    }
    
    func storeActivity(activity: Activity){
        var entity = DataStore.Entity(data: activity, meta: activity.meta())
        dataStore.Save(entity)
    }
    
    func persistUpdatedActivity(id: String, token: String, imageUrl: String, activity: Activity){
        var entity = DataStore.Entity(data: activity, meta: activity.meta())
        entity.Id = id
        entity.CheckTag = token
        entity.imageUrl = imageUrl
        
        dataStore.Save(entity)
    }
    
    func fetchJoinableActivities(user: Individual)->[Activity]{
        var params:[QueryParameter] = []
        params.push(QueryParameter(Name: "initiator", Operator: QueryParameterOperator.Equals, Value: user.email, Negated: true))
        params.push(QueryParameter(Name: "participants", Operator: QueryParameterOperator.Contains, Value: user.email, Negated: true))
        params.push(QueryParameter(Name: "startsOn", Operator: QueryParameterOperator.HigherThan, Value: Int(Utils.currentDate().timeIntervalSince1970 as Double * 1000)))
        params.push(QueryParameter(Name: "isCancelled", Operator: QueryParameterOperator.Equals, Value: "false"))
        params.push(QueryParameter(Name: "isWrapped", Operator: QueryParameterOperator.Equals, Value: "false"))
    
        var activities = dataStore.Query(ChainOperation.And, queryParams: params) as [Activity]

        
        return activities
    }
    
    func fetchActivitiesFor(user: Individual)->[Activity]{
        var params:[QueryParameter] = []
        params.push(QueryParameter(Name: "initiator", Operator: QueryParameterOperator.Equals, Value: user.email))
        params.push(QueryParameter(Name: "startsOn", Operator: QueryParameterOperator.HigherThan, Value: Int(Utils.currentDate().timeIntervalSince1970 as Double * 1000)))
        params.push(QueryParameter(Name: "isCancelled", Operator: QueryParameterOperator.Equals, Value: "false"))
        
        var activities = dataStore.Query(ChainOperation.And, queryParams: params) as [Activity]
        
        return activities
    }
    
    func fetchActivitiesForParticipant(user: Individual)->[Activity]{
        var params:[QueryParameter] = []
        params.push(QueryParameter(Name: "participants", Operator: QueryParameterOperator.Contains, Value: user.email))
        params.push(QueryParameter(Name: "startsOn", Operator: QueryParameterOperator.HigherThan, Value: Int(Utils.currentDate().timeIntervalSince1970 as Double * 1000)))
        params.push(QueryParameter(Name: "isCancelled", Operator: QueryParameterOperator.Equals, Value: "false"))
        
        var activities = dataStore.Query(ChainOperation.And, queryParams: params) as [Activity]
        
        return activities
    }
    
    func joinActivity(id: String, token: String, imageUrl: String, activity: Activity, individual: Individual){
        if (activity.hasParticipant(individual)){
            //This member is already part of the activity
        }
        activity.joinMember(individual)
        
        persistUpdatedActivity(id, token: token, imageUrl: imageUrl, activity: activity)
    }
    
    func leaveActivity(id: String, token: String, imageUrl: String, activity: Activity, individual: Individual, reason:String){
        if (activity.hasParticipant(individual)){
            //activity.leaveMember(individual)
            activity.bailOut(individual, reason: reason)
        }
        persistUpdatedActivity(id, token: token, imageUrl: imageUrl, activity: activity)
    }
}
