//
//  VisualComponent.swift
//  JiYi
//
//  Created by Nohan Budry on 08.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class VisualComponent: GKComponent {
	
	let node: SKNode
	let faceNode: SKNode
	let backNode: SKNode
	
	let foundShape: SKShapeNode
	
	var faceUp: Bool
	
	init(sign: String, traduction: String, faceUp: Bool) {
		
		node = SKNode()
		faceNode = SKNode()
		backNode = SKNode()
		
		self.faceUp = faceUp
		
		//constants
		let cardSize = CGFloat(100)
		
		//back
		let path = UIBezierPath(roundedRect: CGRectMake(0, 0, cardSize, cardSize), cornerRadius: 10)
		
		let card = SKShapeNode(path: path.CGPath, centered: true)
		card.fillColor = SKColor.whiteColor()
		card.strokeColor = SKColor.grayColor()
		card.lineWidth = 5
		
		//faceNode setup
		faceNode.name = "FrontFace"
		
		//sign
		let signLabel = SKLabelNode(fontNamed: "Menlo Bold")
		signLabel.text = sign
		signLabel.fontSize = sign.characters.count <= 3 ? 30 : 80 / CGFloat(sign.characters.count)
		signLabel.fontColor = SKColor.blackColor()
		signLabel.position = CGPointMake(0, 5)
		signLabel.verticalAlignmentMode = .Bottom
		signLabel.horizontalAlignmentMode = .Center
		
		//traduction
		let traductionLabel = SKLabelNode(fontNamed: "Menlo Bold")
		traductionLabel.text = traduction
		traductionLabel.fontSize = traduction.characters.count <= 4 ? 30 : 80 / 0.55 / CGFloat(traduction.characters.count)
		traductionLabel.fontColor = SKColor.blackColor()
		traductionLabel.position = CGPointMake(0, -5)
		traductionLabel.verticalAlignmentMode = .Top
		traductionLabel.horizontalAlignmentMode = .Center
		
		faceNode.addChild(card)
		faceNode.addChild(signLabel)
		faceNode.addChild(traductionLabel)
		
		//backNode creation
		backNode.name = "BackFace"
		
		//text
		let textLabel = SKLabelNode(fontNamed: "Menlo")
		textLabel.text = "Jì Yì"
		textLabel.fontSize = 35
		textLabel.fontColor = SKColor.blackColor()
		textLabel.verticalAlignmentMode = .Center
		textLabel.horizontalAlignmentMode = .Center
		textLabel.zRotation = 45 * CGFloat(M_PI) / 180
		
		backNode.addChild(card.copy() as! SKShapeNode)
		backNode.addChild(textLabel)
		
		node.addChild(faceUp ? faceNode : backNode)
		
		//foundshape
		foundShape = card.copy() as! SKShapeNode
		foundShape.fillColor = SKColor.clearColor()
		foundShape.strokeColor = SKColor(red: 250 / 255, green: 190 / 255, blue: 5 / 255, alpha: 1)
	}
	
	func switchTo(faceUp faceUp: Bool) {
		
		//return if already in good position
		if self.faceUp == faceUp {
			
			return
		}
		
		//get current node
		let currentNode = self.faceUp ? faceNode : backNode
		
		//update self faceUp var
		self.faceUp = faceUp
		
		//get nextNode
		let nextNode = faceUp ? faceNode : backNode
		
		let scaleAction = SKAction.scaleXTo(0, duration: 0.25)
		currentNode.runAction(scaleAction) {
			
			nextNode.xScale = 0
			
			currentNode.removeFromParent()
			self.node.addChild(nextNode)
			
			let scaleAction = SKAction.scaleXTo(nextNode.yScale, duration: 0.25)
			nextNode.runAction(scaleAction)
		}
	}
	
	func enterFoundState() {
		
		node.addChild(foundShape)
	}
}





























