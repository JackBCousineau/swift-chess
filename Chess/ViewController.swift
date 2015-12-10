//
//  ViewController.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//

import Cocoa

class ViewController: NSViewController{
    
    @IBOutlet var side1Label: NSTextField!
    @IBOutlet var side2Label: NSTextField!
    
    @IBOutlet var player1TextField: NSTextField!
    @IBOutlet var player2TextField: NSTextField!
    
    @IBOutlet var iconSetPopUpButton: NSPopUpButton!
    @IBOutlet var iconSetPreviewImageView: NSImageView!
    
    var sidesSwitched = false
    
    // The "switch sides" button event handler. Simply switches the color/starting side of each player.
    @IBAction func switchButtonClicked(button: NSButton){
        sidesSwitched = !sidesSwitched
        if(sidesSwitched){
            side1Label.stringValue = "Black side"
            side2Label.stringValue = "White side"
            return
        }
        side1Label.stringValue = "White side"
        side2Label.stringValue = "Black side"
    }
    
    // The icon set chooser popup-button event handler
    @IBAction func iconSetPopUpAction(popUpButton: NSPopUpButton){
        
        // Sets the icon set preview image to an image of the selected item's lowercase string, with "_preview" appended
        iconSetPreviewImageView.image = NSImage(named: "\((popUpButton.selectedItem?.title.lowercaseString)!)_preview")
    }

    // Holds all active chess games. Without holding a pointer to the new ChessGame object would be immediately deallocated by the garbage collector
    var games = [ChessGame]()
    
    // "Start" button event handler
    @IBAction func startButtonClicked(button: NSButton){
        
        // We grab the user-entered player names from their associated text boxes
        var whiteName = player1TextField.stringValue, blackName = player2TextField.stringValue
        
        // If the sides have been switched, then we invert the white and black player name assignments
        if(sidesSwitched){
            whiteName = blackName
            blackName = player1TextField.stringValue
        }
        
        // We create the new ChessGame object with the given parameters, and add it to the ChessGame array.
        games.append(ChessGame(gameType: .HumanVsHuman, difficulty: nil, whitePlayerName: whiteName, blackPlayerName: blackName, iconSetName: (iconSetPopUpButton.selectedItem?.title)!))
    }
}
