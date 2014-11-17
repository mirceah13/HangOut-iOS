//
//  EndpointCom.swift
//  Hangout
//
//  Created by Recognos on 14/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class EndpointCom: NSObject {
    
    func call(url: String) -> [AnyObject]{
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        var objectsAsJSONStrings:[AnyObject]? = []
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {(response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            
            var dataStr = NSString(data: data, encoding: NSUTF8StringEncoding)
            if (dataStr != ""){
                if ((dataStr?.hasPrefix("[")) != nil){ //we are array of JSON Objects
                    let subStringRange = NSMakeRange(1, (dataStr!.length - 2))
                    dataStr = dataStr?.substringWithRange(subStringRange)
                    objectsAsJSONStrings = dataStr?.componentsSeparatedByString("},") as [AnyObject]?
                    for (index,value) in enumerate(objectsAsJSONStrings!){
                        if (index < objectsAsJSONStrings!.count - 1){
                            objectsAsJSONStrings?[index] = value as String + "}"
                        }
                    }
                } else { //single object
                    objectsAsJSONStrings?.push(dataStr!)
                }
            } else {
                // we don't have a response content
            }
        })
        
    return objectsAsJSONStrings!
    
    }
    
}
