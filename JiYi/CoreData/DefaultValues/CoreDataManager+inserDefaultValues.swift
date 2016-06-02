//
//  DefaultValues.swift
//  JiYi
//
//  Created by Nohan Budry on 02.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData

//MARK: default value manager
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
        let genres = dict["genres"] as! [String]
        
        if let card = insertCard(sign, traduction: traduction, createdbyUser: false, genres: nil) {
            
            for genre in genres {
                
                //add genre of the card and insert if needed
                card.addToGenre(genre, insertIfNeeded: true, createdByUser: false)
            }
        }
    }
}