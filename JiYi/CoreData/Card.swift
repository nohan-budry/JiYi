//
//  Card.swift
//  JiYi
//
//  Created by Nohan Budry on 02.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData


class Card: NSManagedObject {

    @NSManaged var identifier: NSDate
    @NSManaged var sign: String
    @NSManaged var traduction: String
    @NSManaged var createdByUser: Bool
    @NSManaged var genres: NSSet?

}