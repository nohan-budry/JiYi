//
//  PronunciationComponent.swift
//  JiYi
//
//  Created by Nohan Budry on 14.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import AVFoundation
import GameplayKit

class PronunciationComponent: GKComponent {
	
	let card: Card
	var audioPlayer: AVAudioPlayer?
	
	init(card: Card) {
		
		self.card = card
		
		super.init()
		
		instanciatePlayer()
	}
	
	func instanciatePlayer() {
	
		card.instanciatePronunciations(nil)
		audioPlayer = card.pronunciations.first
	}
	
	func play() {
		
		if let player = audioPlayer {
			
			player.play()
		}
	}
	
	func stop() {
		
		if let player = audioPlayer {
			
			player.stop()
			player.currentTime = 0
		}
	}
	
	func replay() {
		
		stop()
		play()
	}
}