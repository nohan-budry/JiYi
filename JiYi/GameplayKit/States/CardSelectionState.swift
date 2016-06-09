//
//  CardsSelectionState.swift
//  JiYi
//
//  Created by Nohan Budry on 09.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import GameplayKit

class CardsSelectionState: GKState {
	
	let memoryBrain: MemoryBrain
	var selectedCards: [CardEntity]!
	
	init(withMemoryBrain: MemoryBrain) {
		
		self.memoryBrain = withMemoryBrain
	}
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		
		switch stateClass {
			
		case is CardsCheckingState.Type:
			
			return true
			
		default:
			
			return false
		}
	}
	
	override func didEnterWithPreviousState(previousState: GKState?) {
		
		selectedCards = []
	}
	
	//MARK: - Game Funcs
	func selectCard(card: CardEntity) {
		
		if !selectedCards.contains(card) {
			
			selectedCards.append(card)
			card.switchTo(faceUp: true)
			
			if selectedCards.count == 2 {
				
				stateMachine!.enterState(CardsCheckingState)
			}
		}
	}
}






















