//
//  User.swift
//  Hangout
//
//  Created by Yosemite Retail on 11/24/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import CoreData

class User: NSManagedObject {
    @NSManaged var userEmail:NSString
    @NSManaged var userName:NSString
}
