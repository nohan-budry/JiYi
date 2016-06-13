//
//  Score.swift
//  JiYi
//
//  Created by Nohan Budry on 13.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData

class Score: NSManagedObject {
	
	@NSManaged var identifier: NSDate
	@NSManaged var msTime: Int
	@NSManaged var nbOfPoints: Int
	@NSManaged var maxPoints: Int
	@NSManaged var nbOfCards: Int
	
	@NSManaged var user: User
	@NSManaged var deck: Deck
	
}