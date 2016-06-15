//
//  EntityManager.swift
//  JiYi
//
//  Created by Nohan Budry on 08.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
	
	var entities = Set<GKEntity>()
	let scene: SKScene
	
	init(scene: SKScene) {
		self.scene = scene
	}
	
	func add(entity: GKEntity, allreadyInScene: Bool, inLayer: SKNode?) {
		
		entities.insert(entity)
		
		//add in scene if needed
		if !allreadyInScene {
			
			if let node = entity.componentForClass(VisualComponent.self)?.node {
				
				if let layer = inLayer {
					
					layer.addChild(node)
					
				} else {
					
					scene.addChild(node)
				}
			}
		}
	}
	
	func remove(entity: GKEntity) {
		
		if let node = entity.componentForClass(VisualComponent.self)?.node {
			node.removeFromParent()
		}
		
		entities.remove(entity)
	}
}