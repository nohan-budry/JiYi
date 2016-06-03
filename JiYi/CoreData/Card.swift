//
//  Card.swift
//  JiYi
//
//  Created by Nohan Budry on 02.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import AVFoundation


class Card: NSManagedObject {

    @NSManaged var identifier: NSDate
    @NSManaged var sign: String
    @NSManaged var traduction: String
    @NSManaged var createdByUser: Bool
    @NSManaged var decks: NSSet
    
    var pronunciations = [AVAudioPlayer]()
    
    func instanciatePronunciations(withDelegate: AVAudioPlayerDelegate?) {
        
        pronunciations = []
        
        var index = 0
        while let path = NSBundle.mainBundle().pathForResource(pronunciationFileName(index), ofType: "mp3") {
            
            let url = NSURL(fileURLWithPath: path)
            var sound: AVAudioPlayer!
            
            do {
                
                try sound = AVAudioPlayer(contentsOfURL: url)
                
            } catch {
                
                print(error)
            }
            
            sound.delegate = withDelegate
            sound.prepareToPlay()
            sound.numberOfLoops = 0
            
            pronunciations.append(sound)
            
            index += 1
        }
    }
    
    func hasPronunciation() -> Bool {
        
        return NSBundle.mainBundle().pathForResource(pronunciationFileName(0), ofType: "mp3") != nil
    }
    
    func pronunciationFileName(index: Int) -> String {
        
        return String(format: "%@%03d", traduction, index)
    }

    func addToDeck(title: String, insertIfNeeded: Bool, createdByUser: Bool)  {
        
        let context = CoreDataManager.managedObjectContext()
        let predicate = NSPredicate(format: "%K LIKE %@", "title", title)
        
        var deckEntities = CoreDataManager.fetchEntities(
            "Deck",
            managedObjectContext: context,
            predicate: predicate,
            sortDescriptors: nil
        ) as! [Deck]
        
        if insertIfNeeded && deckEntities.count == 0 {
        
            if let deck = CoreDataManager.insertDeck(title, createdbyUser: createdByUser, cards:  nil) {
                
                deckEntities.append(deck)
            }
        }
        
        for deck in deckEntities {
            
            deck.cards = deck.cards.setByAddingObject(self)
        }
    }
}