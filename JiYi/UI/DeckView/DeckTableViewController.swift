//
//  DeckTableViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 03.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DeckTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, DeckInfoTableViewControllerDelegate {
    
    var fetchedResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        
        instantiateFetchedResultController()
    }
    
    func instantiateFetchedResultController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Deck")
        let sorter = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sorter]
        
        let context = CoreDataManager.managedObjectContext()
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            
            try fetchedResultController.performFetch()
            
        } catch {
            
            fatalError("Failed to initialize fetched result controller: \(error)")
        }
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        if let deck = fetchedResultController.objectAtIndexPath(indexPath) as? Deck {
            
            let titleLabel = cell.viewWithTag(1000) as! UILabel
            let subtitleLabel = cell.viewWithTag(1001) as! UILabel
            
            titleLabel.text = deck.title
            
            let count = deck.cards.count
            subtitleLabel.text = "\(count) Carte\(count == 1 ? "s": "")"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            //perform an action like giving the delegate when switching the view
            switch identifier {
                
            case "DeckInfoSegue":
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    
                    let deckInfoView = segue.destinationViewController as! DeckInfoTableViewController
                    
                    deckInfoView.delegate = self
                    deckInfoView.deck = fetchedResultController.objectAtIndexPath(indexPath) as? Deck
                    deckInfoView.indexPath = indexPath
                }
                
            case "DeckAddSegue":
                
                let navigationController = segue.destinationViewController as! UINavigationController
                _ = navigationController.topViewController as! DeckEditTableViewController
                //deckEditView.delegate = self
                
            default:
                break
            }
        }
    }
}

//MARK: tableView funcs
extension DeckTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return fetchedResultController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sections = fetchedResultController.sections as [NSFetchedResultsSectionInfo]!
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DeckCell")!
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK: Deck Info Delegate
extension DeckTableViewController {
    
    func deckInfoUpdateDeckList(indexPath: NSIndexPath) {
        
        do {
            
            try fetchedResultController.performFetch()
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                configureCell(cell, indexPath: indexPath)
            }
            
        } catch {
            
            fatalError("Failed to initialize fetched result controller: \(error)")
        }
    }
}

////MARK: Deck Edit Delegate
//extension DeckTableViewController {
//    
//    func deckEditSaveDeck(deck: Deck?, title: String, cards: NSSet, indexPath: NSIndexPath?) -> Bool {
//        
//        if deck == nil {
//            
//            if let _ = CoreDataManager.insertDeck(title, createdbyUser: true, cards: cards) {
//                
//                if CoreDataManager.saveManagedObjectContext() {
//                    
//                    tableView.reloadData()
//                }
//            }
//        }
//        
//        return false
//    }
//    
//    func deckEditExit(controller: DeckEditTableViewController, animated: Bool) {
//        
//        controller.dismissViewControllerAnimated(true, completion: nil)
//    }
//}










