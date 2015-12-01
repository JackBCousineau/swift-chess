//
//  ViewController.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//

import Cocoa

class ViewController: NSViewController, LANManagerDelegate{
    
    @IBOutlet var side1Label: NSTextField!
    @IBOutlet var side2Label: NSTextField!
    
    @IBOutlet var player1TextField: NSTextField!
    @IBOutlet var player2TextField: NSTextField!
    
    
    @IBOutlet var searchButton: NSButton!
    @IBOutlet var stopButton: NSButton!
    @IBOutlet var networkStatusLabel: NSTextField!
    
    @IBOutlet var iconSetPopUpButton: NSPopUpButton!
    @IBOutlet var iconSetPopUpButtonLabel: NSTextField!
    @IBOutlet var iconSetPreviewImageView: NSImageView!
    
    @IBOutlet var startButton: NSButton!
    
    var sidesSwitched = false, networkConnectivityElementsHidden = true
    
    override func viewDidAppear() {
        //searchButton.title = "Search"
        searchButton.title = "Host"
        //stopButton.title = "Stop"
        stopButton.title = "Search"
        toggleNetworkConnectivityElementsHidden(false)
        LANManager.manager.delegate = self
    }
    
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
    
    @IBAction func playersPopUpAction(popUpButton: NSPopUpButton!){
        toggleNetworkConnectivityElementsHidden(popUpButton.selectedItem?.tag != 1)
    }
    
    @IBAction func iconSetPopUpAction(popUpButton: NSPopUpButton){
        iconSetPreviewImageView.image = NSImage(named: "\((popUpButton.selectedItem?.title.lowercaseString)!)_preview")
    }

    var games = [ChessGame]()
    
    @IBAction func startButtonClicked(button: NSButton){
        var whiteName = player1TextField.stringValue, blackName = player2TextField.stringValue
        if(sidesSwitched){
            whiteName = blackName
            blackName = player1TextField.stringValue
        }
        games.append(ChessGame(gameType: .HumanVsHuman, difficulty: nil, whitePlayerName: whiteName, blackPlayerName: blackName, iconSetName: (iconSetPopUpButton.selectedItem?.title)!))
    }
    
    
    @IBAction func searchButtonPressed(button: NSButton){
        if(button.title == "Host"){
            searchButton.title = "STOP"
            LANManager.broadcastHost()
        }
        else{
            searchButton.title = "Host"
            LANManager.stopBroadcastingHost()
        }
        
    }
    
    @IBAction func stopButtonPressed(button: NSButton){
        if(button.title == "Search"){
            stopButton.title = "STOP"
            networkStatusLabel.stringValue = "Searching for other players..."
            LANManager.searchForHosts()
        }
        else{
            stopButton.title = "Search"
            networkStatusLabel.stringValue = "Idle"
            LANManager.stopSearchingForHost()
        }
    }
    
    @IBAction func testButtonClicked(button: NSButton){
        LANManager.testButtonClicked()
    }
    
    func toggleNetworkConnectivityElementsHidden(hidden: Bool){
        //
        // do not execute anything after this line
        // for (int = 0; i < 5; i){ if(this && your != null) return 0;
        // do not execute anything above this line
        //
        if hidden != networkConnectivityElementsHidden{
            networkConnectivityElementsHidden = hidden
            let frame = (view.window?.frame)!, origin = (view.window?.frame.origin)!
            var change = CGFloat(50), lowerChange = CGFloat(-50)
            if(networkConnectivityElementsHidden){
                change *= -1
                lowerChange = 0
            }
            view.window?.setFrame(NSMakeRect(origin.x, origin.y - change/2, frame.width, frame.height + change), display: true)
            for element in [iconSetPopUpButton, iconSetPopUpButtonLabel, iconSetPreviewImageView, startButton]{
                element.frame = NSMakeRect(element.frame.origin.x, element.frame.origin.y + lowerChange, element.frame.width, element.frame.height)
            }
            searchButton.hidden = !searchButton.hidden
            stopButton.hidden = !stopButton.hidden
            networkStatusLabel.hidden = !networkStatusLabel.hidden
        }
    }
    
    func didConnect(peerName: String){
        networkStatusLabel.stringValue = "Connected to \(peerName)"//"CONNECTED!!!!"
    }

}

