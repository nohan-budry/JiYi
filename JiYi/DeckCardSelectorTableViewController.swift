//
//  DeckCardSelectorViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 06.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol DeckCardSelectorTableViewControllerDelegate {
    
    func deckCardSelectorSave(cards: [Card])
}

class DeckCardSelectorTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController!
    var currentCardSet: [Card]!
    var delegate: DeckCardSelectorTableViewControllerDelegate!
    
    override func viewDidLoad() {
        
        instantiateFetchedResultdController()
    }
    
    func instantiateFetchedResultdController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Card")
        let sortDescriptor = NSSortDescriptor(key: "traduction", ascending: true)
        
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
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        if let card = fetchedResultsController.objectAtIndexPath(indexPath) as? Card {
            
            let signLabel = cell.viewWithTag(1000) as! UILabel
            let traductionLabel = cell.viewWithTag(1001) as! UILabel
            
            signLabel.text = card.sign
            traductionLabel.text = card.traduction
        }
    }
    
    func configureCheckmark(cell: UITableViewCell, indexPath: NSIndexPath) {
        
        if let card = fetchedResultsController.objectAtIndexPath(indexPath) as? Card {
            
            let checkmarkLabel = cell.viewWithTag(1002) as! UILabel
            
            checkmarkLabel.hidden = !currentCardSet.contains(card)
        }
    }
}

//MARK: tableView funcs
extension DeckCardSelectorTableViewController {
    
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
        configureCheckmark(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let card = fetchedResultsController.objectAtIndexPath(indexPath) as! Card
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        
            if let index = currentCardSet.indexOf(card) {
                
                currentCardSet.removeAtIndex(index)
                configureCheckmark(cell, indexPath: indexPath)
                
            } else {
                
                currentCardSet.append(card)
                configureCheckmark(cell, indexPath: indexPath)
            }
        }
        
        delegate.deckCardSelectorSave(currentCardSet)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}



















