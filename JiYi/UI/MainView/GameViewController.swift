//
//  GameViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 08.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SpriteKit

class GameViewController: UIViewController {
	
	var user: User!
	var deck: Deck?
	var nbOfPairs: Int!
	
	override func viewDidLoad() {
		
		guard let gameScene = GameScene(fileNamed: "GameScene.sks"), let gameView = self.view as? SKView else {
			
			return
		}
		
		//View configuration
		gameView.showsFPS = false
		gameView.showsNodeCount = false
		gameView.showsPhysics = false
		gameView.ignoresSiblingOrder = true
		
		//Scene configuration
		gameScene.scaleMode = .Fill
		
		gameScene.user = user
		gameScene.deck = deck
		gameScene.nbOfPairs = nbOfPairs
		gameScene.viewController = self
		
		gameView.presentScene(gameScene)
	}
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		
		return .Landscape
	}
}