//
//  MemoryBrain.swift
//  JiYi
//
//  Created by Nohan Budry on 08.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreData

class MemoryBrain {
	
	var deck: Deck
	var nbOfPairs: Int
	
	init(deck: Deck, nbOfPairs: Int) {
		
		self.deck = deck
		self.nbOfPairs = nbOfPairs
	}
}