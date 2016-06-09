//
//  FoundState.swift
//  JiYi
//
//  Created by Nohan Budry on 09.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import GameplayKit

class FoundState: GKState {
	
	let visualComponent: VisualComponent
	
	init(visualComponent: VisualComponent) {
		
		self.visualComponent = visualComponent
	}
	
	override func isValidNextState(stateClass: AnyClass) -> Bool {
		return false
	}
	
	override func didEnterWithPreviousState(previousState: GKState?) {
		
		if previousState is FaceUpState {
			
			visualComponent.enterFoundState()
		}
	}
}