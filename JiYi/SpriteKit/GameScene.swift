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
	var gameMenu: SKNode!
	var topBar: SKNode!
	
	override func didMoveToView(view: SKView) {
		
		topBar = childNodeWithName("TopBar")!
		
		gameMenu = childNodeWithName("GameMenu")!
		gameMenu.hidden = true
		
		memoryBrain = MemoryBrain(cards: cards, nbOfPairs: nbOfPairs, inScene: self)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		for touch in touches {
			
			if gameMenu.hidden {
				
				if let gameArrayIndex = getTouchedCard(touch) {
					
					memoryBrain.cardEntityClicked(gameArrayIndex: gameArrayIndex)
					
				} else if isMenuButtonTouched(touch) {
					
					gameMenu.hidden = false
				}
				
			} else {
				
				let location = touch.locationInNode(gameMenu)
				
				for node in gameMenu.nodesAtPoint(location) {
					
					if node.name == "ContinueButton" {
						
						gameMenu.hidden = true
						
					} else if node.name == "RestartButton" {
						
						print(node.name, " clicked")
						
					} else if node.name == "LeaveButton" {
						
						print(node.name, "clicked")
					}
				}
			}
		}
	}
	
	func getTouchedCard(touch: UITouch) -> Int? {
		
		let location = touch.locationInNode(memoryBrain.gameBoardLayer)
		
		for node in memoryBrain.gameBoardLayer.nodesAtPoint(location) {
			
			if let theNode = node as? NDNode {
				
				return theNode.memoryArrayIndex
			}
		}
		return nil
	}

	func isMenuButtonTouched(touch: UITouch) -> Bool {
		
		let location = touch.locationInNode(topBar)
		
		for node in topBar.nodesAtPoint(location) {
			
			if node.name == "MenuButton" {
					
				return true
			}
		}
		
		return false
	}
}

























