//
//  MainTableViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 07.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainTableViewController: UITableViewController, MainDeckSelectorDelegate {
	
	var user: User!
	var deck: Deck?
	var nbOfPairs = 2
	
	@IBOutlet weak var deckLabel: UILabel!
	@IBOutlet weak var nbOfCardsLabel: UILabel!
	@IBOutlet weak var stepper: UIStepper!
	
	override func viewDidLoad() {
		
		user = CoreDataManager.fetchEntities("User", managedObjectContext: nil, predicate: nil, sortDescriptors: nil).first as! User
		updateInfos()
	}
	
	func updateInfos() {
	
		deckLabel.text = deck != nil ? deck!.title : "Toutes les cartes"
		
		stepper.minimumValue = 2
		stepper.maximumValue = Double(deck != nil ? deck!.cards.count : CoreDataManager.numberOfCards())
		
		if stepper.maximumValue > 16 {
			
			stepper.maximumValue = 16
		}
		
		if nbOfPairs > Int(stepper.maximumValue) {
			
			nbOfPairs = Int(stepper.maximumValue)
		}
		
		nbOfCardsLabel.text = "\(nbOfPairs) Cartes"
	}
	
	@IBAction func stepperValueChanged(sender: UIStepper) {
		
		nbOfPairs = Int(stepper.value)
		updateInfos()
	}
}

//MARK: - Segue
extension MainTableViewController {
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let identifier = segue.identifier {
			
			switch identifier {
			case "DeckSelectorSegue":
				
				let viewController = segue.destinationViewController as! MainDeckSelectorTableViewController
				viewController.delegate = self
				
			case "StartGameSegue":
				
				let viewController = segue.destinationViewController as! GameViewController
				
				viewController.user = user
				viewController.deck = deck
				viewController.nbOfPairs = nbOfPairs
				
			default:
				break
			}
		}
	}
}

//MARK: - Deck Selector Delegate
extension MainTableViewController {
	
	func mainDeckSelectorSaveSelectedDeck(deck: Deck?) {
		
		self.deck = deck
		updateInfos()
		
		if let navigationController = self.navigationController {
			
			navigationController.popToViewController(self, animated: true)
		}
	}
}























