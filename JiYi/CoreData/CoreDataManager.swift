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
    
	class func fetchEntities(className: NSString, managedObjectContext: NSManagedObjectContext?, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [NSManagedObject] {
		
		let context = managedObjectContext != nil ? managedObjectContext! : self.managedObjectContext()
		
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = NSEntityDescription.entityForName(className as String, inManagedObjectContext: context)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            
            return try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
        } catch {
            
            print(error)
            return []
        }
    }
	
	class func removeEntity(entity: NSManagedObject) -> Bool {
		
		let context = managedObjectContext()
		context.deleteObject(entity)
		
		return saveManagedObjectContext()
	}
}

//MARK: - Card
extension CoreDataManager {
    
    class func insertCard(sign sign: String, traduction: String, createdbyUser: Bool, decks: NSSet?) -> Card? {
        
        let context = managedObjectContext()
        let card = insertManagedObject("Card", managedObjectContext: context) as! Card
        
        card.identifier = NSDate()
        card.sign = sign
        card.traduction = traduction
        card.createdByUser = createdbyUser
        card.decks = decks != nil ? decks! : NSSet()
        
        return saveManagedObjectContext() ? card : nil
    }
	
	class func numberOfCards() -> Int {
	
		return fetchEntities("Card", managedObjectContext: nil, predicate: nil, sortDescriptors: nil).count
	}
}

//MARK: - Deck
extension CoreDataManager {
    
    class func insertDeck(title title: String, createdbyUser: Bool, cards: NSSet?) -> Deck? {
        
        let context = managedObjectContext()
        let deck = insertManagedObject("Deck", managedObjectContext: context) as! Deck
        
        deck.identifier = NSDate()
        deck.title = title
        deck.createdByUser = createdbyUser
        deck.cards = cards != nil ? cards! : NSSet()
		deck.scores = NSSet()
        
        return saveManagedObjectContext() ? deck : nil
    }
}

//MARK: - User
extension CoreDataManager {
	
	class func insertUser(username username: String) -> User? {
		
		let context = managedObjectContext()
		let user = insertManagedObject("User", managedObjectContext: context) as! User
		
		user.identifier = NSDate()
		user.username = username
		user.scores = NSSet()
		
		return saveManagedObjectContext() ? user : nil
	}
}

//MARK: - Score
extension CoreDataManager {
	
	class func insertScore(msTime msTime: Int, nbOfPoints: Int, maxPoints: Int, nbOfPairs: Int, user: User, deck: Deck?) -> Score? {
		
		let context = managedObjectContext()
		let score = insertManagedObject("Score", managedObjectContext: context) as! Score
		
		score.identifier = NSDate()
		score.msTime = msTime
		score.nbOfPoints = nbOfPoints
		score.maxPoints = maxPoints
		score.nbOfPairs = nbOfPairs
		score.user = user
		score.deck = deck
		
		return saveManagedObjectContext() ? score : nil
	}
}

//MARK: - DefaultValues
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
		
		if let card = insertCard(sign: sign, traduction: traduction, createdbyUser: false, decks: nil) {
			
			for deck in decks {
				
				//add deck of the card and insert if needed
				card.addToDeck(deck, insertIfNeeded: true, createdByUser: false)
			}
		}
	}
}


















