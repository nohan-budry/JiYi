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
			
			memoryBrain.showEndText(createEndText())
		}
	}
	
	func createEndText() -> SKNode {
		
		let backPath = UIBezierPath(roundedRect: CGRectMake(0, 0, 500, 250), cornerRadius: 25)
		let backShapeNode = SKShapeNode(path: backPath.CGPath, centered: true)
		backShapeNode.strokeColor = UIColor.grayColor()
		backShapeNode.lineWidth = 10
		backShapeNode.fillColor = UIColor.whiteColor()
		backShapeNode.zPosition = 100
		backShapeNode.position = CGPointMake(memoryBrain.scene.size.width / 2, memoryBrain.scene.size.height / 2)
		
		let text1Label = SKLabelNode(fontNamed: "Menlo")
		text1Label.fontSize = 25
		text1Label.fontColor = SKColor.blackColor()
		text1Label.text = "Bravo! Vous avez gagner!"
		text1Label.position.y = text1Label.fontSize * 2
		
		let text2Label = SKLabelNode(fontNamed: "Menlo")
		text2Label.fontSize = 25
		text2Label.fontColor = SKColor.blackColor()
		text2Label.text = "Votre score final est: \(memoryBrain.gameArray.count)"
		
		let text3Label = SKLabelNode(fontNamed: "Menlo")
		text3Label.fontSize = 25
		text3Label.fontColor = SKColor.blackColor()
		text3Label.text = "Utilisez le menu pour rejouer."
		text3Label.position.y = -text1Label.fontSize * 2
		
		backShapeNode.addChild(text1Label)
		backShapeNode.addChild(text2Label)
		backShapeNode.addChild(text3Label)
		
		return backShapeNode
	}
}
















