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

class MainTableViewController: UITableViewController, MainDeckSelectorDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	
	var deck: Deck?
	var nbOfPairs = 2
	
	@IBOutlet weak var deckLabel: UILabel!
	@IBOutlet weak var cardCountPickerView: UIPickerView!
	
	override func viewDidLoad() {
		
		updateInfos()
	}
	
	func updateInfos() {
	
		deckLabel.text = deck != nil ? deck!.title : "Toutes les cartes"
		cardCountPickerView.reloadComponent(0)
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
				
				let cards = deck != nil ?
					deck!.cards.allObjects as! [Card] :
					CoreDataManager.fetchEntities(
						"Card",
						managedObjectContext: CoreDataManager.managedObjectContext(),
						predicate: nil,
						sortDescriptors: nil
					) as! [Card]
				
				viewController.cards = cards
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

//MARK: - Picker View Delegete && DataSource
extension MainTableViewController {
	
	var possiblesNbOfCards: [Int] {
		
		let maxCount = deck == nil ? CoreDataManager.numberOfCards() : deck!.cards.count
		var counts = [Int]()
		
		//count limit by me !!!
		let limitMinCount = 2
		let limitMaxCount = 16
		
		for i in limitMinCount ... limitMaxCount {
			
			if i > maxCount {
				
				break
			}
			
			counts.append(i)
		}
		
		return counts
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return possiblesNbOfCards.count
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		nbOfPairs = possiblesNbOfCards[row]
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return "\(possiblesNbOfCards[row])"
	}
}























