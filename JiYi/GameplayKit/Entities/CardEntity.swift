//
//  CardEntity.swift
//  JiYi
//
//  Created by Nohan Budry on 08.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CardEntity: GKEntity {
	
	let card: Card
	
	init(card: Card, spacement: CGFloat, cardSize: CGFloat, cardsPerLine: [CGFloat], index: Int, nbOfCards: Int) {
		
		self.card = card
		
		super.init()
		
		let visualComponent = VisualComponent(
			sign: card.sign,
			traduction: card.traduction,
			faceUp: false,
			spacement: spacement,
			cardSize: cardSize,
			cardsPerLine: cardsPerLine,
			index: index,
			nbOfCards: nbOfCards
		)
		
		addComponent(visualComponent)
	}
}