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
   
    var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var context: NSManagedObjectContext
    
    override init() {
        context = appDel.managedObjectContext!
    }
    
    func save(entity: String, parameters: Dictionary<String, String>) -> Bool{
        
        var newEntity = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: context) as NSManagedObject
        
        for (key, value) in parameters{
            newEntity.setValue(value, forKey: key)
        }
        
        return context.save(nil);
    }
    
    func list(entity: String) -> [Activity] {
        var activities:[Activity] = []
        
        var url:String = "http://h-httpstore.azurewebsites.net/h-hang-out-activities/?chainWith=And&initiator=!Equals:dan.hintea@recognos.ro&participants=!Contains:dan.hintea@recognos.ro@startsOn=HigherThan:1415704137899&isCancelled=Equals:false&isWrapped=Equals:false"
        
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        var response: AutoreleasingUnsafeMutablePointer <NSURLResponse?>=nil
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: nil)
    
        var objectsJSONStrings:[String]? = []
            
        var datastr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        if (datastr != ""){
            if ((datastr?.hasPrefix("[")) != nil){ //we are array of JSON Objects
                let subStringRange = NSMakeRange(1, (datastr!.length - 2))
                datastr = datastr?.substringWithRange(subStringRange)
                let separator:NSString = ",{"  + "\"" + "Id" + "\"" + ":"
                objectsJSONStrings = datastr?.componentsSeparatedByString(separator) as [AnyObject]? as [String]?
                for (index,value) in enumerate(objectsJSONStrings!){
                    if (index > 0){ //add ,{"Id"
                        objectsJSONStrings?[index] = "{\"Id\":" + value.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            as String
                    }
                }
            }
            for item in objectsJSONStrings!{
                    
            var act:Activity = Activity(JSONString: item as String)
            activities.push(act)
            }
        }
        return activities
    }
    
    func remove(entity: String, key:String, value:String) -> Bool {
        
        var request = NSFetchRequest(entityName: entity)
        
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "\(key) = %@", value)
        
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
