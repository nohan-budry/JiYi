//
//  NDNode.swift
//  JiYi
//
//  Created by Nohan Budry on 09.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import SpriteKit

class NDNode: SKNode {
	
	let memoryArrayIndex: Int
	
	init(inMemoryArrayIndex: Int) {
		
		self.memoryArrayIndex = inMemoryArrayIndex
		
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}