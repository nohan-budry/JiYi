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
	
	var faceUp: Bool
	
	init(sign: String, traduction: String, faceUp: Bool) {
		
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
		
		//text
		let textLabel = SKLabelNode(fontNamed: "Menlo")
		textLabel.text = "Jì Yì"
		textLabel.fontSize = 35
		textLabel.fontColor = SKColor.blackColor()
		textLabel.verticalAlignmentMode = .Center
		textLabel.horizontalAlignmentMode = .Center
		
		backNode.addChild(card)
		backNode.addChild(textLabel)
		
		node = faceUp ? faceNode : backNode
	}
}





























