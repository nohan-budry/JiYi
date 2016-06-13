//
//  ScoreTableViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 13.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScoreTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	var _fetchedResultsController: NSFetchedResultsController!
	
	func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
		
		if let score = fetchedResultsController.objectAtIndexPath(indexPath) as? Score {
			
			let timeLabel = cell.viewWithTag(1000) as! UILabel
			let scoreLabel = cell.viewWithTag(1001) as! UILabel
			let deckNameLabel = cell.viewWithTag(1002) as! UILabel
			let dateLabel = cell.viewWithTag(1003) as! UILabel
			
			let seconds = score.msTime / 1000
			timeLabel.text = String(format: "%02d:%02d", seconds / 60 % 60, seconds % 60)
			
			scoreLabel.text = "\(score.nbOfPoints)/\(score.maxPoints)"
			
			deckNameLabel.text = score.deck != nil ? score.deck!.title : "Toutes les cartes"
			
			let formatter = NSDateFormatter()
			formatter.dateFormat = "hh:mm dd:MM:YY"
			dateLabel.text = "\(formatter.stringFromDate(score.identifier))"
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		
		navigationController?.popViewControllerAnimated(true)
	}
}

//MARK: - Table View
extension ScoreTableViewController {
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return fetchedResultsController.sections!.count
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let sections = fetchedResultsController.sections as [NSFetchedResultsSectionInfo]!
		return sections[section].numberOfObjects
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell")!
		configureCell(cell, indexPath: indexPath)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		if let sectionInfo = fetchedResultsController.sections?[section] {
			
			if let score = sectionInfo.objects?.first as? Score {
				
				return "\(score.nbOfPairs) Paires"
			}
		}
		return nil
	}
}

//MARK: - Fetched Results Controller
extension ScoreTableViewController {
	
	var fetchedResultsController: NSFetchedResultsController {
		
		if _fetchedResultsController == nil { //create new fetched results controller if needed
			
			//setup request
			let fetchRequest = NSFetchRequest(entityName: "Score")
			//setup sorters
			let sorters = [
				NSSortDescriptor(key: "nbOfPairs", ascending: true),
				NSSortDescriptor(key: "nbOfPoints", ascending: false),
				NSSortDescriptor(key: "msTime", ascending: true)
			]
			fetchRequest.sortDescriptors = sorters
			
			let context = CoreDataManager.managedObjectContext()
			
			//setup fetched results controller
			let fetchedResultsController = NSFetchedResultsController(
				fetchRequest: fetchRequest,
				managedObjectContext: context,
				sectionNameKeyPath: "nbOfPairs",
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