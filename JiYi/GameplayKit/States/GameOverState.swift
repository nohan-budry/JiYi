//
//  GameOverState.swift
//  JiYi
//
//  Created by Nohan Budry on 09.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameOverState: GKState {
	
	let memoryBrain: MemoryBrain
	
	init(withMemoryBrain: MemoryBrain) {
		
		self.memoryBrain = withMemoryBrain
	}
	
	override func didEnterWithPreviousState(previousState: GKState?) {
		
		if previousState is CardsCheckingState {
			
			memoryBrain.showEndText()
		}
	}
	
}
















