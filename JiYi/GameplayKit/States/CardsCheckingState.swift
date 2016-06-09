//
//  CardsCheckingState.swift
//  JiYi
//
//  Created by Nohan Budry on 09.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import GameplayKit

class CardsCheckingState: GKState {
	
	let memoryBrain: MemoryBrain
	
	init(withMemoryBrain: MemoryBrain) {
		
		self.memoryBrain = withMemoryBrain
	}
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		
		switch stateClass {
			
		case is CardsSelectionState.Type/*,
		     is GameOverState.Type*/:
			
			return true
			
		default:
			return false
		}
	}
	
	override func didEnterWithPreviousState(previousState: GKState?) {
		
		if let state = previousState as? CardsSelectionState {
			
			let cards = state.selectedCards
			memoryBrain.showCheckResult(cards, equals: testCards(cards))
		}
	}
	
	//MARK: - Game Funcs
	func testCards(cards: [CardEntity]) -> Bool {
		
		var entities = cards
		let traduction = entities.removeFirst().card.traduction
		print(traduction)
		
		for entity in entities {
			print(entity.card.traduction)
			if entity.card.traduction != traduction {
				return false
			}
		}
		
		return true
	}
}












