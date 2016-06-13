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
	
	var user: User!
	var deck: Deck?
	var nbOfPairs: Int!
	var memoryBrain: MemoryBrain!
	var gameMenu: SKNode!
	var topBar: SKNode!
	
	var viewController: UIViewController!
	
	override func didMoveToView(view: SKView) {
		
		topBar = childNodeWithName("TopBar")!
		
		gameMenu = childNodeWithName("GameMenu")!
		
		newGame()
	}
	
	func newGame() {
		
		gameMenu.hidden = true
		memoryBrain = MemoryBrain(user: user, deck: deck, nbOfPairs: nbOfPairs, inScene: self)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		for touch in touches {
			
			if gameMenu.hidden {
				
				if let gameArrayIndex = getTouchedCard(touch) {
					
					memoryBrain.cardEntityClicked(gameArrayIndex: gameArrayIndex)
					
				} else if isMenuButtonTouched(touch) {
					
					gameMenu.hidden = false
					memoryBrain.menuButtonCLicked()
				}
				
			} else {
				
				let location = touch.locationInNode(gameMenu)
				
				for node in gameMenu.nodesAtPoint(location) {
					
					if node.name == "ContinueButton" {
						
						gameMenu.hidden = true
						memoryBrain.continueButtonClicked()
						
					} else if node.name == "RestartButton" {
						
						memoryBrain.restartButtonClicked()
						
					} else if node.name == "LeaveButton" {
						
						memoryBrain.leaveButtonClicked()
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
	
	func leaveGame() {
		
		viewController.dismissViewControllerAnimated(true, completion: nil)
	}
}

























