//
//  DataStore.swift
//  Hangout
//
//  Created by Yosemite Retail on 11/21/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class DataStore: NSObject {
    var storeUrl: String = ""
    var storeName: String = "http://h-httpstore.azurewebsites.net/h-hang-out-activities"
    
    init(storeUrl: String, storeName: String){
        self.storeUrl = storeUrl
        self.storeName = storeName
    }
    
    init(storeName: String){
        self.storeName = storeName
        self.storeUrl = "http://h-httpstore.azurewebsites.net/h-hang-out-activities"
    }
    
    override init(){
        super.init()
    }
    /*
    func Query(queryParams: [QueryParameter]) -> NSDictionary{
        return self.Query(ChainOperation.And, queryParams: queryParams)
    }
*/
    
    func Query(chain: ChainOperation, queryParams: [QueryParameter]) -> [AnyObject]{
        var url = self.GenerateQueryUrl(chain, queryParams: queryParams)
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        var response: AutoreleasingUnsafeMutablePointer <NSURLResponse?>=nil
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: nil)
        var datastr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        var objectsJSONStrings:[String]? = []
        
        if (datastr != ""){

            var entities = PersistenceHelper.ToObjects(datastr!)
            
            return entities!
        }
        
        return []
    }
    
    func QueryMeta(queryParams: [QueryParameter]) -> NSDictionary{
        return self.QueryMeta(ChainOperation.And, queryParams: queryParams)
    }
    
    func QueryMeta(chain: ChainOperation, queryParams: [QueryParameter]) -> NSDictionary{
        var url = self.GenerateQueryMetaUrl(chain, queryParams: queryParams)
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        var response: AutoreleasingUnsafeMutablePointer <NSURLResponse?>=nil
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: nil)
        var datastr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        //var meta = PersistenceHelper.ToMeta(datastr!)
        //return meta
        
        return NSDictionary()
    }
    
    func GenerateQueryUrl(chain:ChainOperation, queryParams: [QueryParameter]) -> NSString{
        var paramsString = ""
        
        for param in queryParams{
            paramsString = paramsString + param.ToString() + "&"
        }
        paramsString = paramsString.substringToIndex(paramsString.endIndex.predecessor())
        
        return "\(self.storeName)/?chainWith=\(ChainOperation.fromEnum(chain))&\(paramsString)"
    }
    
    func GenerateQueryMetaUrl(chain:ChainOperation, queryParams: [QueryParameter]) -> NSString{
        var paramsString = ""
        
        for param in queryParams{
            paramsString = paramsString + param.ToString() + "&"
        }
        paramsString = paramsString.substringToIndex(paramsString.endIndex.predecessor())
        
        return "\(self.storeUrl)meta/\(self.storeName)/?chainWith=\(chain)&\(paramsString)"
    }
    
    func Load(id: String) -> AnyObject {
        var url = ""
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        var response: AutoreleasingUnsafeMutablePointer <NSURLResponse?>=nil
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: nil)
        var datastr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        var entities = PersistenceHelper.ToObjects(datastr!) as [AnyObject]!
        return entities[0]
    }
    
    func Save(entity: AnyObject){
        var url = ""
        var request:NSMutableURLRequest = NSMutableURLRequest()
        var session = NSURLSession.sharedSession()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "PUT"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(entity, options: nil, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
    
    func Delete(id: NSUUID){
        //TODO
    }
    
    class Entity: NSObject {
        var id:String = ""
        var checkTag: String = ""
        var data: AnyObject?
        var meta: AnyObject?
        
        init(data: AnyObject, meta: AnyObject ){
            self.data = data
            self.meta = meta
        }
        /*
        func fromDto(dto: AnyObject){
            var entity = Entity(data: dto.data!, meta: dto.meta!)
            entity.id = dto.id
            entity.checkTag = dto.checkTag
        }
        ß*/
    }
    
}
