//
//  User.swift
//  JiYi
//
//  Created by Nohan Budry on 13.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {
	
	@NSManaged var identifier: NSDate
	@NSManaged var username: String
	
	@NSManaged var scores: NSSet
}