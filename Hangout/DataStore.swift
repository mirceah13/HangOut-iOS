//
//  DataStore.swift
//  Hangout
//
//  Created by Yosemite Retail on 11/21/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class DataStore: NSObject {
    var storeUrl: String = "Default"
    var storeName: String = "http://localhost/HttpDataStore"
    
    init(storeUrl: String, storeName: String){
        self.storeUrl = storeUrl
        self.storeName = storeName
    }
    
    init(storeName: String){
        self.storeName = storeName
        self.storeUrl = "http://localhost/HttpDataStore"
    }
    
    func Query(chain: ChainOperation, queryParams: [QueryParameter]) -> NSDictionary{
        return self.Query(ChainOperation.And, queryParams: queryParams)
    }
    
    func Query(chain: ChainOperation, queryParams: [QueryParameter]) -> [AnyObject]{
        var url = self.GenerateQueryUrl(chain, queryParams: queryParams)
        var request:NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        var response: AutoreleasingUnsafeMutablePointer <NSURLResponse?>=nil
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: nil)
        var datastr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        var entities = PersistenceHelper.ToObjects(datastr!)
        
        return entities!
        
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
        
        return "\(self.storeUrl)/\(self.storeName)/?chainWith=\(chain)&\(paramsString)"
    }
    
    func GenerateQueryMetaUrl(chain:ChainOperation, queryParams: [QueryParameter]) -> NSString{
        var paramsString = ""
        
        for param in queryParams{
            paramsString = paramsString + param.ToString() + "&"
        }
        paramsString = paramsString.substringToIndex(paramsString.endIndex.predecessor())
        
        return "\(self.storeUrl)meta/\(self.storeName)/?chainWith=\(chain)&\(paramsString)"
    }
    
    func Load(id: NSUUID) -> AnyObject {
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
        //TODO
    }
    
    func Delete(id: NSUUID){
        //TODO
    }
}
