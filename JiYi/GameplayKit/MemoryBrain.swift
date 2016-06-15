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
	
	let user: User
	let deck: Deck?
	let nbOfPairs: Int
	let scene: GameScene
	var gameArray: [CardEntity]!
	
	//layers
	let gameBoardLayer: SKNode
	let menuLayer: SKSpriteNode
	
	//managers
	let entityManager: EntityManager
	var stateMachine: GKStateMachine!
	
	//constants
	let defaultCardSize: CGFloat = 100
	let defaultSpacement: CGFloat = 15
	
	//timer
	var gameTimer: NSTimer!
	var currentMsTime = 0
	var timerLabel: SKLabelNode!
	
	//score
	var gameScore = 0
	let scorePerCards: Int
	let scorePerFails: Int
	let scorePerFound: Int
	var scoreLabel: SKLabelNode!
	
	init(user: User, deck: Deck?, nbOfPairs: Int, inScene: GameScene) {
		
		self.user = user
		self.deck = deck
		self.nbOfPairs = nbOfPairs
		self.scene = inScene
		
		entityManager = EntityManager(scene: inScene)
		
		//layers setup
		
		menuLayer = scene.childNodeWithName("TopBar") as! SKSpriteNode
		
		gameBoardLayer = SKNode()
		scene.addChild(gameBoardLayer)
		
		//score
		scoreLabel = menuLayer.childNodeWithName("ScoreLabel") as! SKLabelNode
		scorePerCards = 10
		scorePerFails = -10
		scorePerFound = 0
		gameScore = getMaxScore()
		showScore()
		
		//timer
		timerLabel = menuLayer.childNodeWithName("TimerLabel") as! SKLabelNode
		startGameTimer()
		
		//createStateMachine
		stateMachine = GKStateMachine(
			states: [
				GamePreparationState(withMemoryBrain: self),
				CardsSelectionState(withMemoryBrain: self),
				CardsCheckingState(withMemoryBrain: self),
				GameOverState(withMemoryBrain: self)
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
		let cardSize = defaultCardSize * cardScale
		let totalCardSize = CGSizeMake(
			cardsPerLine[0] * (cardSize + defaultSpacement) + defaultSpacement,
			CGFloat(cardsPerLine.count) * (cardSize + defaultSpacement) + defaultSpacement
		)
		
		gameBoardLayer.position = CGPointMake(
			(gameBoradSize.width - totalCardSize.width) / 2 + cardSize / 2 + defaultSpacement,
			(gameBoradSize.height - totalCardSize.height) / 2 + cardSize / 2 + defaultSpacement
		)
		
		//MARK: - Card Array Setup
		
		let possibleCards = deck != nil ?
			deck!.cards.allObjects as! [Card] :
			CoreDataManager.fetchEntities("Card", managedObjectContext: nil, predicate: nil, sortDescriptors: nil) as! [Card]
		
		//create a shuffuled array of possible sign
		let randomSource = GKRandomSource()
		var shuffuledPossibleSigns = randomSource.arrayByShufflingObjectsInArray(possibleCards) as! [Card]
		
		//get used signs
		var keepedSigns = [Card]()
		for _ in 0 ..< nbOfPairs {
			
			keepedSigns.append(shuffuledPossibleSigns.removeFirst())
		}
		
		//double the array to have each signe twice and shuffle the array
		keepedSigns.appendContentsOf(keepedSigns)
		let cards = randomSource.arrayByShufflingObjectsInArray(keepedSigns) as! [Card]
		self.gameArray = []
		
		//createEntities
		var index = 0
		for card in cards {
			
			let cardEntity = CardEntity(
				card: card,
				spacement: defaultSpacement,
				cardSize: defaultCardSize * cardScale,
				cardsPerLine: cardsPerLine,
				index: index,
				nbOfCards: cards.count
			)
			self.gameArray.append(cardEntity)
			entityManager.add(cardEntity, allreadyInScene: false, inLayer: gameBoardLayer)
			
			index += 1
		}
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
	
	//MARK: - Menu
	func menuButtonCLicked() {
		
		stopGameTimer()
	}
	
	func continueButtonClicked() {
		
		startGameTimer()
	}
	
	func restartButtonClicked() {
		
		//remove gamelayer and cards from vue
		for card in gameArray {
			
			entityManager.remove(card)
		}
		gameBoardLayer.removeFromParent()
		
		//remove timer
		stopGameTimer()
		
		//tell the scene to create a new game
		scene.newGame()
	}
	
	func leaveButtonClicked() {
		
		scene.leaveGame()
	}
	
	func cardEntityClicked(gameArrayIndex index: Int) {
		
		let entity = gameArray[index]
		
		
		switch entity.stateMachine.currentState {
			
		case is FaceUpState, is FoundState:
			
			//play pronunciation if in good state
			entity.playSound()
			
		default:
			
			break
		}
		
		if let state = stateMachine.currentState as? CardsSelectionState {
			
			if entity.stateMachine.currentState is FaceDownState {
				
				state.selectCard(entity)
			}
		}
	}
	
	//MARK: - Score
	func showScore() {
		
		scoreLabel.text = "\(gameScore)/\(getMaxScore())"
	}
	
	func showCheckResult(cards: [CardEntity], equals: Bool) {
		
		let waitAction = SKAction.waitForDuration(equals ? 0.5 : 2.0)
		gameBoardLayer.runAction(waitAction) {
			
			for card in cards {
				
				if equals {
					
					card.found()
					
				} else {
					
					card.switchTo(faceUp: false)
				}
			}
			
			self.addScore(found: equals)
			
			if !self.isGameFinished() {
				
				self.stateMachine.enterState(CardsSelectionState)
				
			} else {
				
				self.stateMachine.enterState(GameOverState)
			}
		}
	}
	
	//MARK: - End text
	func showEndText() {
		
		let node = createEndText()
		node.alpha = 0
		
		scene.addChild(node)
		
		let fadeIn = SKAction.fadeInWithDuration(0.25)
		let wait = SKAction.waitForDuration(5.0)
		let fadeOut = SKAction.fadeOutWithDuration(0.25)
		
		node.runAction(SKAction.sequence([fadeIn, wait, fadeOut])) {
			
			node.removeFromParent()
		}
	}
	
	func createEndText() -> SKNode {
		
		let backPath = UIBezierPath(roundedRect: CGRectMake(0, 0, 650, 250), cornerRadius: 25)
		let backShapeNode = SKShapeNode(path: backPath.CGPath, centered: true)
		backShapeNode.strokeColor = UIColor.grayColor()
		backShapeNode.lineWidth = 10
		backShapeNode.fillColor = UIColor.whiteColor()
		backShapeNode.zPosition = 100
		backShapeNode.position = CGPointMake(scene.size.width / 2, scene.size.height / 2)
		
		let text1Label = SKLabelNode(fontNamed: "Menlo")
		text1Label.fontSize = 25
		text1Label.fontColor = SKColor.blackColor()
		text1Label.text = "Bravo \(user.username)!"
		text1Label.position.y = text1Label.fontSize * 2
		
		let text2Label = SKLabelNode(fontNamed: "Menlo")
		text2Label.fontSize = 25
		text2Label.fontColor = SKColor.blackColor()
		text2Label.text = "Votre score final est: \(gameScore)/\(getMaxScore())"
		
		let text3Label = SKLabelNode(fontNamed: "Menlo")
		text3Label.fontSize = 25
		text3Label.fontColor = SKColor.blackColor()
		text3Label.text = "Utilisez le menu pour rejouer ou quitter."
		text3Label.position.y = -text1Label.fontSize * 2
		
		backShapeNode.addChild(text1Label)
		backShapeNode.addChild(text2Label)
		backShapeNode.addChild(text3Label)
		
		return backShapeNode
	}
}

//MARK: - Game Funcs
extension MemoryBrain {
	
	func addScore(found found: Bool) {
		
		gameScore += found ? scorePerFound : scorePerFails
		showScore()
	}
	
	func getMaxScore() -> Int {
		
		return scorePerCards * nbOfPairs * 2
	}
	
	func isGameFinished() -> Bool {
		
		for card in gameArray {
			
			if !(card.stateMachine.currentState is FoundState) {
				
				return false
			}
		}
		
		stopGameTimer()
		saveFinishedGame()
		return true
	}
	
	func saveFinishedGame() {
		
		CoreDataManager.insertScore(
			msTime: currentMsTime,
			nbOfPoints: gameScore,
			maxPoints: getMaxScore(),
			nbOfPairs: nbOfPairs,
			user: user,
			deck: deck
		)
	}
	
	func testCards(cards: [CardEntity]) -> Bool {
		
		var entities = cards
		let traduction = entities.removeFirst().card.traduction
		
		for entity in entities {
			
			if entity.card.traduction != traduction {
				return false
			}
		}
		
		return true
	}
	
	@objc func gameTimerTick() {
		
		currentMsTime += 100
		
		let seconds = currentMsTime / 1000
		timerLabel.text = String(format: "%02d:%02d", seconds / 60 % 60, seconds % 60)
	}
}

//MARK: - Timer
extension MemoryBrain {
	
	func startGameTimer() {
		
		gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(gameTimerTick), userInfo: nil, repeats: true)
	}
	
	func stopGameTimer() {
		
		gameTimer.invalidate()
	}
}



































