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
    
    static func fromEnum(op: QueryParameterOperator) -> String{
        for item in QueryParameterOperator.allValues{
            if (item == op){
                return item.rawValue
            }
        }
        return "Equals"
    }
}

enum ChainOperation : String
{
    case And = "And", Or = "Or"
    
    static let allValues = [And, Or]
    static func toEnum(stringValue: String) -> ChainOperation{
        for item in ChainOperation.allValues{
            if (item.rawValue == stringValue){
                return item
            }
        }
        return And
    }
    
    static func fromEnum(chain: ChainOperation) -> String{
        for item in ChainOperation.allValues{
            if (item == chain){
                return item.rawValue
            }
        }
        return "And"
    }

}

enum DefaultMessageFor: String
{
    case success = "Operation completed successfully",
         failure = "Cannot complete the operation, please try again or contact us"
}


class QueryParameter: NSObject {
    var Name:String = ""
    var Operator:QueryParameterOperator
    var Value:AnyObject
    var Negated:Bool = false
    
    init(Name:String, Operator:QueryParameterOperator, Value:AnyObject, Negated: Bool = false){
        self.Name = Name
        self.Operator = Operator
        self.Value = Value
        self.Negated = Negated
    }
    
    func ToString() -> String {
        var negationStr = self.Negated ? "!" : ""
        return "\(self.Name)=\(negationStr)\(QueryParameterOperator.fromEnum(self.Operator)):\(self.Value)"
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
            asInt = i
            return asInt!
        }
        
        //if let d = value.toDecimal(){
        //    return asDecimal
        //}
        //if value is NSDecimal {return asDecimal}
        return asInt!
    }
    
}
