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
    @NSManaged var genres: NSSet

    func addToGenre(title: String, insertIfNeeded: Bool, createdByUser: Bool)  {
        
        let context = CoreDataManager.managedObjectContext()
        let predicate = NSPredicate(format: "%K LIKE %@", "title", title)
        
        var genreEntities = CoreDataManager.fetchEntities(
            "Genre",
            managedObjectContext: context,
            predicate: predicate,
            sortDescriptors: nil
        ) as! [Genre]
        
        if insertIfNeeded && genreEntities.count == 0 {
        
            if let genre = CoreDataManager.insertGenre(title, createdbyUser: createdByUser, cards:  nil) {
                
                genreEntities.append(genre)
            }
        }
        
        for genre in genreEntities {
            
            genre.cards = genre.cards.setByAddingObject(self)
        }
    }
}