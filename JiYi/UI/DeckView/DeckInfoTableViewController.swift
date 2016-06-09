//
//  DeckInfoViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 03.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DeckInfoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController!
    
    var deck: Deck!
    
    @IBOutlet weak var editbarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        if let _ = deck {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        instantiateFetchedResultdController()
        editbarButton.enabled = deck.createdByUser
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
    }
    
    func instantiateFetchedResultdController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Card")
        let predicate = NSPredicate(format: "decks.title CONTAINS %@", deck.title)
        let sortDescriptor = NSSortDescriptor(key: "traduction", ascending: true)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = CoreDataManager.managedObjectContext()
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            
            try fetchedResultsController.performFetch()
            
        } catch {
            
            fatalError("Failed to initialize fetched result controller: \(error)")
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let sectionInfo = fetchedResultsController.sections?[section] {
            
            let cards = sectionInfo.objects
            if let card = cards?.first as? Card {
                
                for deck in card.decks.allObjects as! [Deck] {
                    
                    if deck.identifier == self.deck.identifier {
                        
                        return deck.title
                    }
                }
            }
        }
        
        return nil
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        if let card = fetchedResultsController.objectAtIndexPath(indexPath) as? Card {
            
            let signLabel = cell.viewWithTag(1000) as! UILabel
            let traductionLabel = cell.viewWithTag(1001) as! UILabel
            let pronunciationlabel = cell.viewWithTag(1002) as! UILabel
            
            signLabel.text = card.sign
            traductionLabel.text = card.traduction
            pronunciationlabel.hidden = !card.hasPronunciation()
            
            if !pronunciationlabel.hidden {
                
                card.instanciatePronunciations(nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            //perform an action like giving the delegate when switching the view
            switch identifier {
            
            case "DeckEditSegue":
                
                let navigationController = segue.destinationViewController as! UINavigationController
                let deckEditView = navigationController.topViewController as! DeckEditTableViewController
                
                deckEditView.deck = deck!
                deckEditView.title = "Modifier le deck"
            
            default:
                break
            }
        }
    }
}

//MARK: - Table View
extension DeckInfoTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sections = fetchedResultsController.sections as [NSFetchedResultsSectionInfo]!
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CardCell")!
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let card = fetchedResultsController.objectAtIndexPath(indexPath) as? Card {
            if card.hasPronunciation() {
                
                if let sound = card.pronunciations.first {
                    
                    sound.play()
                }
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK: - Fetched Results Controller Delegate
extension DeckInfoTableViewController {
    
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












