//
//  ViewController.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//  Copyright © 2015 Jack Cousineau. All rights reserved.
//

import Cocoa

class ViewController: NSViewController{
    
    @IBOutlet var side1Label: NSTextField!
    @IBOutlet var side2Label: NSTextField!
    
    @IBOutlet var player1TextField: NSTextField!
    @IBOutlet var player2TextField: NSTextField!
    
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

    var games = [ChessGame]()
    
    @IBAction func startButtonClicked(button: NSButton){
        if(!sidesSwitched){
            games.append(ChessGame(gameType: .HumanVsHuman, difficulty: nil, whitePlayerName: player1TextField.stringValue, blackPlayerName: player2TextField.stringValue))
            return
        }
        games.append(ChessGame(gameType: .HumanVsHuman, difficulty: nil, whitePlayerName: player2TextField.stringValue, blackPlayerName: player1TextField.stringValue))
    }


}

