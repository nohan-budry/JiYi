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
	
	let cards: [Card]
	let nbOfPairs: Int
	let scene: SKScene
	
	//layers
	let gameBoardLayer: SKNode
	let menuLayer: SKSpriteNode
	
	//managers
	let entityManager: EntityManager
	var stateMachine: GKStateMachine!
	
	//constants
	let defaultCardSize: CGFloat = 100
	let defaultSpacement: CGFloat = 15
	
	init(cards: [Card], nbOfPairs: Int, inScene: SKScene) {
		
		self.cards = cards
		self.nbOfPairs = nbOfPairs
		self.scene = inScene
		
		entityManager = EntityManager(scene: inScene)
		
		//layers setup
		
		menuLayer = scene.childNodeWithName("MenuNode") as! SKSpriteNode
		
		gameBoardLayer = SKNode()
		scene.addChild(gameBoardLayer)
		
		//createStateMachine
		stateMachine = GKStateMachine(
			states: [
				GamePreparationState(withMemoryBrain: self)
			]
		)
		
		stateMachine.enterState(GamePreparationState)
	}
	
	func setupGame() {
		
		//Setup needed values
		let gameBoradSize = CGSizeMake(scene.size.width, scene.size.height - menuLayer.size.height)
		
		let cardsPerLine = getCardsPerLine(nbOfPairs)
		let cardScale = getBetterCardScale(
			boardSize: gameBoradSize,
			space: defaultSpacement,
			nbsOfCards: (cardsPerLine[0], CGFloat(cardsPerLine.count)),
			cardSize: defaultCardSize
		)
		
		//place gameBoard
		let modifier = defaultSpacement + defaultCardSize * cardScale
		gameBoardLayer.position = CGPointMake(modifier, gameBoradSize.height - modifier)
	}
}

//MARK: - UI

extension MemoryBrain {
	
	func getCardScale(length: CGFloat, space: CGFloat, nbOfCards: CGFloat, cardSize: CGFloat) -> CGFloat {
		
		//get the good scale to fit the length
		return (length - (nbOfCards + 1) * space) / nbOfCards / cardSize
	}
	
	func getBetterCardScale(boardSize size: CGSize, space: CGFloat, nbsOfCards: (x: CGFloat, y: CGFloat), cardSize: CGFloat) -> CGFloat {
		
		let xRatio = getCardScale(size.width, space: space, nbOfCards: nbsOfCards.x, cardSize: cardSize)
		let yRatio = getCardScale(size.height, space: space, nbOfCards: nbsOfCards.y, cardSize: cardSize)
		
		//get the best scale that fit the screen
		return xRatio < yRatio ? xRatio : yRatio
	}
	
	func getCardsPerLine(nbOfPairs: Int) -> [CGFloat] {
		
		if nbOfPairs >= 7 {
			
			//calculate card count for each lines
			let isEven = nbOfPairs % 2 == 0
			var lines = [CGFloat]()
			
			/*
			for line 0 and 1
			card count
			-> nbOfPairs / 2, if nbOfPairs is even
			-> (nbOfPairs + 1) / 2, if nbOfPairs is odd
			*/
			for _ in 0 ..< 2 {
				
				lines.append(isEven ? CGFloat(nbOfPairs) / 2 : CGFloat(nbOfPairs + 1) / 2)
			}
			
			/*
			for line 2 and 3
			card count
			-> nbOfPairs / 2, if nbOfPairs is even
			-> (nbOfPairs - 1) / 2, if nbOfPairs is odd
			*/
			for _ in 0 ..< 2 {
				
				lines.append(isEven ? CGFloat(nbOfPairs) / 2 : CGFloat(nbOfPairs - 1) / 2)
			}
			
			return lines
		}
		
		//for values less than 7 -> the algorythm can't be used
		switch nbOfPairs {
			
		case 6:
			return [4, 4, 4]
			
		case 5:
			return [4, 3, 3]
			
		case 4, 3, 2:
			return [CGFloat(nbOfPairs), CGFloat(nbOfPairs)]
			
		default: // if less than 2 pairs, can't play
			return []
		}
	}
}




































