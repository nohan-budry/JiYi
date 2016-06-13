//
//  ProfileEditTableViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 13.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProfileEditTableViewController: UITableViewController, UITextFieldDelegate {
	
	var user: User!
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		
		usernameTextField.text = user.username
	}
	
	@IBAction func save() {
		
		user.username = usernameTextField.text!
		CoreDataManager.saveManagedObjectContext()
		
		cancel()
	}
	
	@IBAction func cancel() {
		
		dismissViewControllerAnimated(true, completion: nil)
	}
}

//MARK: - Text Field Delegate
extension ProfileEditTableViewController {
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		
		saveButton.enabled = false
		
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
		
		let username = getText(fromOldText: textField.text!, inRange: range, replacementString: string) as String
		
		saveButton.enabled = canEnableSaveButton(username)
		
		return true
	}
	
	func getText(fromOldText old: String, inRange range: NSRange, replacementString str: String) -> NSString {
		
		let txt: NSString = old
		return txt.stringByReplacingCharactersInRange(range, withString: str)
		
	}
	
	func canEnableSaveButton(username: String) -> Bool {
		
		return username.characters.count > 0
	}
}