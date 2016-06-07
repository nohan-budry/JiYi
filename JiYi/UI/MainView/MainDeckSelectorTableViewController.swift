//
//  MainDeckSelectorTableViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 07.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol MainDeckSelectorDelegate {
	
	func mainDeckSelectorSaveSelectedDeck(deck: Deck?)
}

class MainDeckSelectorTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	var _fetchedResultsController: NSFetchedResultsController!
	var delegate: MainDeckSelectorDelegate!
}

//MARK: - Fetched Results Controller
extension MainDeckSelectorTableViewController {
	
	var fetchedResultsController: NSFetchedResultsController {
		
		if _fetchedResultsController == nil { //create new fetched results controller if needed
		
			//setup request
			let fetchRequest = NSFetchRequest(entityName: "Deck")
			//setup sorters
			let sorters = [
				NSSortDescriptor(key: "createdByUser", ascending: true),
				NSSortDescriptor(key: "title", ascending: true)
			]
			fetchRequest.sortDescriptors = sorters
			
			let context = CoreDataManager.managedObjectContext()
			
			//setup fetched results controller
			let fetchedResultsController = NSFetchedResultsController(
				fetchRequest: fetchRequest,
				managedObjectContext: context,
				sectionNameKeyPath: "createdByUser",
				cacheName: nil
			)
			
			fetchedResultsController.delegate = self
			
			do {
				
				try fetchedResultsController.performFetch()
				
			} catch {
				
				fatalError("Failed to initialize fetched result controller: \(error)")
			}
			
			//set property
			_fetchedResultsController = fetchedResultsController
		}
		
		return _fetchedResultsController
	}
}

//MARK: - Table View
extension MainDeckSelectorTableViewController {
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		return fetchedResultsController.sections!.count + 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if isLastSection(section) {
			
			return 1
		}
		
		let sections = fetchedResultsController.sections as [NSFetchedResultsSectionInfo]!
		
		return sections[section].numberOfObjects
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("DeckCell")!
		configureCell(cell, indexPath: indexPath)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		delegate.mainDeckSelectorSaveSelectedDeck(!isLastSection(indexPath.section) ? fetchedResultsController.objectAtIndexPath(indexPath) as? Deck : nil)
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		if isLastSection(section) {
			
			return "Autres"
			
		} else if let sectionInfo = fetchedResultsController.sections?[section] {
			
			let decks = sectionInfo.objects
			if let deck = decks?.first as? Deck {
				
				return deck.createdByUser ? "Mes decks" : "Decks par défaut"
			}
		}
		return nil
	}
	
	func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
		
		let titleLabel = cell.viewWithTag(1000) as! UILabel
		let subtitleLabel = cell.viewWithTag(1001) as! UILabel
		
		if isLastSection(indexPath.section) {
			
			titleLabel.text = "Toutes les cartes"
			
			let count = CoreDataManager.numberOfCards()
			subtitleLabel.text = "\(count) Carte\(count == 1 ? "s": "")"
		
		} else if let deck = fetchedResultsController.objectAtIndexPath(indexPath) as? Deck {
			
			titleLabel.text = deck.title
			
			let count = deck.cards.count
			subtitleLabel.text = "\(count) Carte\(count == 1 ? "s": "")"
			
		}
	}
	
	func isLastSection(section: Int) -> Bool {
		
		return section == numberOfSectionsInTableView(tableView) - 1
	}
}

















