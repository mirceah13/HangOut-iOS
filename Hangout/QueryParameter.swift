//
//  QueryParameter.swift
//  Hangout
//
//  Created by Yosemite Retail on 11/21/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

enum QueryParameterOperator: String
{
    case
    Equals = "Equals",
    LowerThan = "LowerThan",
    LowerThanOrEqual = "LowerThasnOrEqual",
    HigherThan = "HigherThan",
    HigherThanOrEqual = "HigherThanOrEqual",
    Contains = "Contains",
    BeginsWith = "BeginsWith",
    EndsWith = "EndsWith"
    
    static let allValues = [Equals, LowerThan, LowerThanOrEqual, HigherThan, HigherThanOrEqual, Contains, BeginsWith, EndsWith]
    static func toEnum(stringValue: String) -> QueryParameterOperator{
        for item in QueryParameterOperator.allValues{
            if (item.rawValue == stringValue){
                return item
            }
        }
        return Equals
    }
}

enum ChainOperation
{
    case And
    case Or
}


class QueryParameter: NSObject {
    var Name:String = ""
    var Operator:QueryParameterOperator
    var Value:AnyObject
    
    init(Name:String, Operator:QueryParameterOperator, Value:AnyObject){
        self.Name = Name
        self.Operator = Operator
        self.Value = Value
    }
    
    func ToString() -> String {
        return "\(self.Name)=\(self.Operator):\(self.Value)"
    }
    
    class func Parse(name:String, queryCondition:String) -> QueryParameter{
        
        var parts = queryCondition.componentsSeparatedByString(":") as [AnyObject]? as [String]
        if (parts.count != 2){
            //Error. The query condition has an invalid format. It should be <Operator>:<Value>
        }
        
        var op = parts[0] as String
        return QueryParameter(Name: name, Operator: QueryParameterOperator.toEnum(op), Value: parts[1] as AnyObject!)
    }
    
    class func ParseValue(value: String) -> AnyObject{
        var asInt: Int?
        var asDecimal: NSDecimalNumber?
        var asDateTime: NSDate?
        var asBool: Bool?
        
        //if let b = Bool( {
        //        return asBool
        //}
        
        if let i = value.toInt(){
            return asInt!
        }
        
        //if let d = value.toDecimal(){
        //    return asDecimal
        //}
        //if value is NSDecimal {return asDecimal}
        return asInt!
    }
    
}
