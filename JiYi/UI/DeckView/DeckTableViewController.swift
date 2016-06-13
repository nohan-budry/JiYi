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

class DeckTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        
        instantiateFetchedResultController()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
    }
    
    func instantiateFetchedResultController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Deck")
		let sorters = [
			NSSortDescriptor(key: "createdByUser", ascending: true),
			NSSortDescriptor(key: "title", ascending: true)
		]
        fetchRequest.sortDescriptors = sorters
        
        let context = CoreDataManager.managedObjectContext()
        
        fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "createdByUser",
            cacheName: nil
        )
        
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
                    
                    deckInfoView.deck = fetchedResultController.objectAtIndexPath(indexPath) as? Deck
                }
                
            default:
                break
            }
        }
    }
}

//MARK: - Table View
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sectionInfo = fetchedResultController.sections?[section] {
            
            let decks = sectionInfo.objects
            if let deck = decks?.first as? Deck {
                
                return deck.createdByUser ? "Mes decks" : "Decks par défaut"
            }
        }
        return nil
    }
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		if let deck = fetchedResultController.objectAtIndexPath(indexPath) as? Deck {
			
			return deck.createdByUser
		}
		
		return false
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let deck = fetchedResultController.objectAtIndexPath(indexPath) as? Deck else {
			
			return
		}
		
		if editingStyle == .Delete {
				
			CoreDataManager.removeEntity(deck)
		}
	}
}

//MARK: - Fetched Results Controller Delegate
extension DeckTableViewController {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}










