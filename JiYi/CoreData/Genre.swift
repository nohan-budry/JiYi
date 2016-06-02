//
//  Genre.swift
//  JiYi
//
//  Created by Nohan Budry on 02.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData


class Genre: NSManagedObject {

    @NSManaged var identifier: NSDate
    @NSManaged var title: String
    @NSManaged var createdByUser: Bool
    @NSManaged var cards: NSSet

}
