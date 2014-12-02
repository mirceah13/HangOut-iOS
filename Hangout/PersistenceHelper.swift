//
//  PersistenceHelper.swift
//  Hangout
//
//  Created by Recognos on 09/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit
import CoreData

class PersistenceHelper: NSObject {
    
    var dataService:DataService = DataService()
    
    class func ToObjects(datastr: NSString) -> [AnyObject]? {
        var entities:[AnyObject] = []
        var objectsJSONStrings:[String]? = []
        
        if (datastr != ""){
            if ((datastr.hasPrefix("["))){ //we are array of JSON Objects
                let subStringRange = NSMakeRange(1, (datastr.length - 2))
                let ds = datastr.substringWithRange(subStringRange)
                let separator:NSString = ",{"  + "\"" + "Id" + "\"" + ":"
                objectsJSONStrings = ds.componentsSeparatedByString(separator) as [AnyObject]? as [String]?
                for (index,value) in enumerate(objectsJSONStrings!){
                    if (index > 0){ //add ,{"Id"
                        objectsJSONStrings?[index] = "{\"Id\":" + value.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            as String
                    }
                }
            }
            for item in objectsJSONStrings!{
                
                var act:Activity = Activity(JSONString: item as String)
                entities.push(act)
            }
        }
        return entities
    }
    
    func list(user:Individual, type: ActivityScreenType) -> [AnyObject]{
        var activities:[AnyObject] = []
        if (type == ActivityScreenType.JoinableActivities){
            activities = dataService.fetchJoinableActivities(user)
        }
        if (type == ActivityScreenType.JoinedActivities){
            activities = dataService.fetchActivitiesForParticipant(user)
        }
        if (type == ActivityScreenType.YourActitivies){
            activities = dataService.fetchActivitiesFor(user)
        }
        return activities
    }
    
    func joinActivity(activity: Activity, individual: Individual){
        dataService.joinActivity(activity.id, token: activity.checkTag, activity: activity, individual: individual)
    }
    
    class func saveUserToCoreData(email: String, name: String) -> Bool{
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.managedObjectContext!
        let newEntity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        var newUser = User(entity: newEntity!, insertIntoManagedObjectContext: context)
        newUser.userEmail = email
        newUser.userName = name
        
        return context.save(nil);
    }
    class func loadUserFromCoreData(email: String) -> [AnyObject]{
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "userEmail = %@" , email)
        var result:NSArray = context.executeFetchRequest(request, error: nil)!
        
        return result
    }
    
    class func removeUserFromCoreData() -> Bool {
        let appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)!
        
        if (results.count > 0){
            var res = results[0] as NSManagedObject
            
            context.deleteObject(res)
            
            context.save(nil)
            
            return true
        }
        
        return false
    }
    
    
}
