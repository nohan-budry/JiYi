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

class ProfileTableViewController: UITableViewController, UITextFieldDelegate {
	
	var user: User!
	
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var showScoresLabel: UILabel!
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		self.user = CoreDataManager.fetchEntities("User", managedObjectContext: nil, predicate: nil, sortDescriptors: nil).first as! User
		
		//setup view
		usernameLabel.text = user.username
		
		let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: false)
		
		let scores = user.scores.sortedArrayUsingDescriptors([sortDescriptor]) as! [Score]
			showScoresLabel.text = scores.count == 0 ? "Aucune parties jouées" :  "Afficher les scores"
	}
	
	//MARK: - Segue
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let identifier = segue.identifier {
			
			switch identifier {
			case "ProfileEditSegue":
				
				let navigationController = segue.destinationViewController as! UINavigationController
				let viewController = navigationController.topViewController as! ProfileEditTableViewController
				
				viewController.user = user
				
			default:
				
				break
			}
		}
	}
}






















