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
    
    class func insertCard(sign: String, traduction: String, createdbyUser: Bool, decks: NSSet?) -> Card? {
        
        let context = managedObjectContext()
        let card = insertManagedObject("Card", managedObjectContext: context) as! Card
        
        card.identifier = NSDate()
        card.sign = sign
        card.traduction = traduction
        card.createdByUser = createdbyUser
        card.decks = decks != nil ? decks! : NSSet()
        
        return saveManagedObjectContext() ? card : nil
    }
}

//MARK: Deck entity funcs
extension CoreDataManager {
    
    class func insertDeck(title: String, createdbyUser: Bool, cards: NSSet?) -> Deck? {
        
        let context = managedObjectContext()
        let deck = insertManagedObject("Deck", managedObjectContext: context) as! Deck
        
        deck.identifier = NSDate()
        deck.title = title
        deck.createdByUser = createdbyUser
        deck.cards = cards != nil ? cards! : NSSet()
        
        return saveManagedObjectContext() ? deck : nil
    }
}

//MARK: default values manager
extension CoreDataManager {
    
    class func insertDefaultValues() -> Bool {
        
        let path = NSBundle.mainBundle().pathForResource("Cards", ofType: "plist")
        let dict = NSArray(contentsOfFile: path!) as! [AnyObject]
        
        for cardDict in dict {
            
            insertCardWithDefaultValues(cardDict as! [String:AnyObject])
        }
        
        return saveManagedObjectContext()
    }
    
    class func insertCardWithDefaultValues(dict: [String:AnyObject]) {
        
        let sign = dict["sign"] as! String
        let traduction = dict["traduction"] as! String
        let decks = dict["decks"] as! [String]
        
        if let card = insertCard(sign, traduction: traduction, createdbyUser: false, decks: nil) {
            
            for deck in decks {
                
                //add deck of the card and insert if needed
                card.addToDeck(deck, insertIfNeeded: true, createdByUser: false)
            }
        }
    }
}


















