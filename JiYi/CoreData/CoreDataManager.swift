//
//  CoreDataManager.swift
//  JiYi
//
//  Created by Nohan Budry on 02.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    class func managedObjectContext() -> NSManagedObjectContext {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }
    
    class func saveManagedObjectContext() -> Bool {
        
        do {
            
            try managedObjectContext().save()
            return true
        
        } catch {
            
            print(error)
            return false
        }
    }
    
    class func insertManagedObject(className: NSString, managedObjectContext: NSManagedObjectContext) -> NSManagedObject {
        
        return NSEntityDescription.insertNewObjectForEntityForName(className as String, inManagedObjectContext: managedObjectContext)
    }
    
    class func fetchEntities(className: NSString, managedObjectContext: NSManagedObjectContext, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = NSEntityDescription.entityForName(className as String, inManagedObjectContext: managedObjectContext)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            
            return try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
        } catch {
            
            print(error)
            return []
        }
        
    }
}

//MARK: Card entity funcs
extension CoreDataManager {
    
    class func insertCard(sign: String, traduction: String, createdbyUser: Bool, genres: NSSet?) -> Card? {
        
        let context = managedObjectContext()
        let card = insertManagedObject("Card", managedObjectContext: context) as! Card
        
        card.identifier = NSDate()
        card.sign = sign
        card.traduction = traduction
        card.createdByUser = createdbyUser
        card.genres = genres
        
        return saveManagedObjectContext() ? card : nil
    }
}

//MARK: Genre entity funcs
extension CoreDataManager {
    
    class func insertGenre(title: String, createdbyUser: Bool, cards: NSSet?) -> Genre? {
        
        let context = managedObjectContext()
        let genre = insertManagedObject("Genre", managedObjectContext: context) as! Genre
        
        genre.identifier = NSDate()
        genre.title = title
        genre.createdByUser = createdbyUser
        genre.cards = cards
        
        return saveManagedObjectContext() ? genre : nil
    }
}


















