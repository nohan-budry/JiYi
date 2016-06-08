//
//  GamePreparationState.swift
//  JiYi
//
//  Created by Nohan Budry on 08.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class GamePreparationState: GKState {
	
	let memoryBrain: MemoryBrain
	
	init(withMemoryBrain: MemoryBrain) {
		
		self.memoryBrain = withMemoryBrain
	}
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		
		//can only go to CardSlectionState
		switch stateClass {
			
//		case is CardSelectionState.Type:
//			
//			return true
			
		default:
			
			return false
		}
	}
	
	override func didEnterWithPreviousState(previousState: GKState?) {
		
		if previousState == nil {
			
			memoryBrain.setupGame()
			if let _ = self.stateMachine {
				
				print("Enter CardSelectionState now!")
//				print(stateMachine.enterState(CardSelectionState))
			}
		}
	}
}