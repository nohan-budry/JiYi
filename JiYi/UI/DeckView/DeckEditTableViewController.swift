//
//  DeckEditTableViewController.swift
//  JiYi
//
//  Created by Nohan Budry on 03.06.16.
//  Copyright © 2016 Nodev. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DeckEditTableViewController: UITableViewController, UITextFieldDelegate, DeckCardSelectorDelegate {
    
    var deck: Deck?
    var cards: NSSet!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nbCardsLabel: UILabel!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        cards = deck != nil ? deck!.cards : NSSet()
        
        titleTextField.text = deck?.title
        configueCardCountlabel(cards.count)
        
        doneBarButton.enabled = canEnableDoneBarButton(titleTextField.text!)
    }
    
    @IBAction func cancel() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done() {
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            //perform an action like giving the delegate when switching the view
            switch identifier {
                
            case "CardSelectorSegue":
                
                let viewController = segue.destinationViewController as! DeckCardSelectorTableViewController
                
                viewController.delegate = self
                viewController.deckCards = cards.allObjects as! [Card]
                
            default:
                break
            }
        }
    }
    
    func configueCardCountlabel(count: Int) {
        
        nbCardsLabel.text = "\(count) Carte\(count == 1 ? "s": "") (minimum 2 cartes)"
    }
}

//MARK: text field delegate {
extension DeckEditTableViewController {
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        doneBarButton.enabled = false
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,replacementString string: String) -> Bool {
        
        let title = getText(fromOldText: textField.text!, inRange: range, replacementString: string) as String
        
        doneBarButton.enabled = canEnableDoneBarButton(title)
        
        return true
    }
    
    func getText(fromOldText old: String, inRange range: NSRange, replacementString str: String) -> NSString {
        
        let txt: NSString = old
        return txt.stringByReplacingCharactersInRange(range, withString: str)
        
    }
    
    func canEnableDoneBarButton(title: String) -> Bool {
    
        return title.characters.count > 0 && cards.count >= 2
    }
}

//MARK: deck card selector Delegate
extension DeckEditTableViewController {
    
    func deckCardSelectorSaveList(cards: [Card]) {
        
        let cardSet = NSSet(array: cards)
        self.cards = cardSet
        
        configueCardCountlabel(cards.count)
        doneBarButton.enabled = canEnableDoneBarButton(titleTextField.text!)
    }
}



















