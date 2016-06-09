//
//  FaceDownState.swift
//  JiYi
//
//  Created by Nohan Budry on 09.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import GameplayKit

class FaceDownState: GKState {
	
	let visualComponent: VisualComponent
	
	init(visualComponent: VisualComponent) {
		
		self.visualComponent = visualComponent
	}
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		
		switch stateClass {
			
		case is FaceUpState.Type:
			
			return true
			
		default:
			
			return false
		}
	}
	
	override func didEnterWithPreviousState(previousState: GKState?) {
		
		if previousState is FaceUpState {
			
			visualComponent.switchTo(faceUp: false)
		}
	}
}