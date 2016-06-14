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
	var stateMachine: GKStateMachine!
	
	init(card: Card, spacement: CGFloat, cardSize: CGFloat, cardsPerLine: [CGFloat], index: Int, nbOfCards: Int) {
		
		self.card = card
		
		super.init()
		
		//create visual component
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
		
		//create pronunciation component
		let pronunciationComponent = PronunciationComponent(card: card)
		addComponent(pronunciationComponent)
		
		//create state machine
		stateMachine = GKStateMachine(
			states: [
				FaceDownState(visualComponent: visualComponent),
				FaceUpState(visualComponent: visualComponent),
				FoundState(visualComponent: visualComponent)
			]
		)
		stateMachine.enterState(FaceDownState)
	}
	
	func switchTo(faceUp faceUp: Bool)  {
		
		if faceUp {
		
			stateMachine.enterState(FaceUpState)
			
		} else {
			
			stateMachine.enterState(FaceDownState)
		}
	}
	
	func found() -> Bool {
		
		return stateMachine.enterState(FoundState)
	}
	
	func playSound() {
		
		if let pronunciationComponent = componentForClass(PronunciationComponent) {
			
			pronunciationComponent.play()
		}
	}
}













