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
    
    @IBAction func iconSetPopUpAction(popUpButton: NSPopUpButton){
        //print((popUpButton.selectedItem?.title)!)
        //print("\((popUpButton.selectedItem?.title)!)_preview")
        iconSetPreviewImageView.image = NSImage(named: "\((popUpButton.selectedItem?.title.lowercaseString)!)_preview")
    }

    var games = [ChessGame]()
    
    @IBAction func startButtonClicked(button: NSButton){
        var whiteName = player1TextField.stringValue, blackName = player2TextField.stringValue
        if(sidesSwitched){
            whiteName = blackName
            blackName = player1TextField.stringValue
            //games.append(ChessGame(gameType: .HumanVsHuman, difficulty: nil, whitePlayerName: player1TextField.stringValue, blackPlayerName: player2TextField.stringValue, iconSetName: (iconSetPopUpButton.selectedItem?.title)!))
            //return
        }
        //games.append(ChessGame(gameType: .HumanVsHuman, difficulty: nil, whitePlayerName: player2TextField.stringValue, blackPlayerName: player1TextField.stringValue, iconSetName: (iconSetPopUpButton.selectedItem?.title)!))
        games.append(ChessGame(gameType: .HumanVsHuman, difficulty: nil, whitePlayerName: whiteName, blackPlayerName: blackName, iconSetName: (iconSetPopUpButton.selectedItem?.title)!))
    }
    
    // was 243
    // 35, 208


}

