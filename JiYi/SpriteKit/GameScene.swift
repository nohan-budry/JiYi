//
//  GameScene.swift
//  JiYi
//
//  Created by Nohan Budry on 08.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
	
	var cards: [Card]!
	var nbOfPairs: Int!
	var memoryBrain: MemoryBrain!
	
	override func didMoveToView(view: SKView) {
		
		memoryBrain = MemoryBrain(cards: cards, nbOfPairs: nbOfPairs, inScene: self)
	}
}