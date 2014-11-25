//
//  TaskManager.swift
//  Hangout
//
//  Created by Recognos on 07/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

var actManager:ActivityManager = ActivityManager()

class ActivityManager: NSObject {
    
    var activities = [Activity]()
    
    var persistenceHelper: PersistenceHelper = PersistenceHelper()
    
    override init() {
        var tempActivities:NSArray = persistenceHelper.list("Activity")
        
        activities = tempActivities as [Activity]
    }
    
    func addActivity(name: String, desc: String){
        /*
        var dicActivity: Dictionary<String, String> = Dictionary<String, String>()
        
        dicActivity["name"] = name
        
        dicActivity["desc"] = desc
        
        if(persistenceHelper.save("Activity", parameters: dicActivity)){
            activities.append(Activity(name: name, description: desc))
        }
        */
    }
    
    func removeActivity(index:Int){
        /*
        var value:String = activities[index].title
        
        if(persistenceHelper.remove("Activity", key: "name", value: value)){
            
            activities.removeAtIndex(index)
        }
        */
    }
}
