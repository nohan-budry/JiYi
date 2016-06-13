//
//  ProfileTableViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 13.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProfileTableViewController: UITableViewController {
	
	var user: User!
	
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var lastGameLabel: UILabel!
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		self.user = (CoreDataManager.fetchEntities("User", managedObjectContext: nil, predicate: nil, sortDescriptors: nil) as! [User]).first!
		
		//setup view
		userNameLabel.text = user.username
		
		let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: false)
		
		let scores = user.scores.sortedArrayUsingDescriptors([sortDescriptor]) as! [Score]
		if let lastScore = scores.first {
			
			lastGameLabel.text = "Dernière partie le: \(lastScore.identifier)"
			
		} else {
			
			lastGameLabel.text = "Aucune parties jouées"
		}
	}
}






















