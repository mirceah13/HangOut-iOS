//
//  JSONPath.swift
//  SwiftJSONParser
//
//  Created by mrap on 8/27/14.
//  Copyright (c) 2014 Mike Rapadas. All rights reserved.
//

import Foundation

class JSONPath {
    let path: String?
    var pathComponents = Array<String>()

    init(_ path: String?) {
        if let nsPath = path as NSString? {
            self.path = path
            pathComponents = nsPath.componentsSeparatedByString(".") as Array<String>
        }
    }

    func popNext() -> String? {
        if pathComponents.isEmpty { return nil }
        return pathComponents.removeAtIndex(0)
    }
    
    class func getArrayKeyAndIndex(optionalKey: String?) -> (String?, Int?)? {
        if let key = optionalKey as String? {
            var arrayKey: String?
            var arrayIndex: Int?
            var itr = 0

            // Match the key of the array and the index
            let regex:NSRegularExpression = NSRegularExpression(pattern: "\\w+(?=\\[)|(?<=\\w\\[)(\\d+)(?=\\])", options: nil, error: nil)!
            //for match in (key =~ "\\w+(?=\\[)|(?<=\\w\\[)(\\d+)(?=\\])") {
            for match in regex.matchesInString(key, options: nil, range: NSMakeRange(0, countElements(key))) as [String]{
                if (itr == 0) {
                    arrayKey = match
                } else {
                    arrayIndex = match.toInt()
                }
                ++itr
            }
            return (arrayKey, arrayIndex)
        }

        return nil
    }
}
