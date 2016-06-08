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
	
	init(card: Card) {
		super.init()
		
		let visualComponent = VisualComponent(sign: card.sign, traduction: card.traduction, faceUp: false)
		addComponent(visualComponent)
	}
}