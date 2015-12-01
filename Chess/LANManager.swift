//
//  LANManager.swift
//  Chess
//
//  Created by Jack Cousineau on 11/15/15.
//  Copyright © 2015 Jack Cousineau. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

// MCPeerID represents DEVICE ON WHICH APP IS RUNNING

protocol LANManagerDelegate{
    
    func didConnect(peerName: String)
}

class LANManager : NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate{
    
    var delegate : LANManagerDelegate!
    
    static var manager = LANManager()
    let selfID = MCPeerID(displayName: NSHost.currentHost().localizedName!)
    let testPeerID = MCPeerID(displayName: "testerBrowser")
    lazy var serviceAdvertiser : MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: manager.selfID, discoveryInfo: nil, serviceType: "chesslan")
        //let advertiser = MCNearbyServiceAdvertiser(peer: manager.testPeerID, discoveryInfo: nil, serviceType: "chess-lan")
        advertiser.delegate = manager
        return advertiser
    }()
    lazy var serviceBrowser : MCNearbyServiceBrowser = {
        //let browser = MCNearbyServiceBrowser(peer: manager.selfID, serviceType: "chess-lan")
        let browser = MCNearbyServiceBrowser(peer: manager.testPeerID, serviceType: "chesslan")
        browser.delegate = manager
        return browser
    }()
    var selfSession : MCSession!
    var advertiserSession: MCSession!
    var browserSession: MCSession!
    
    var foundPeers = [MCPeerID]()
    
    override init(){
        super.init()
        print("Init")
        
        selfSession = MCSession(peer: selfID)
        selfSession.delegate = self
    }
    
    class func testButtonClicked(){
        print("LOOKING FOR SIGNALS")
    }
    
    class func searchForHosts(){
        print("\(manager.selfID.displayName) is now browsing for advertisers")
        manager.serviceBrowser.startBrowsingForPeers()
    }
    
    class func stopSearchingForHost(){
        print("\(manager.selfID.displayName) is STOPPING browsing for advertisers")
        manager.serviceBrowser.stopBrowsingForPeers()
        manager.browserSession.disconnect()
    }
    
    
    class func broadcastHost(){
        print("Now advertising \(manager.selfID.displayName)")
        manager.serviceAdvertiser.startAdvertisingPeer()
    }
    
    class func stopBroadcastingHost(){
        print("STOPPING advertising \(manager.selfID.displayName)")
        manager.serviceAdvertiser.stopAdvertisingPeer()
        manager.selfSession.disconnect()
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError){
        print("Host could not start avertising peer!")
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void){
        print("\(advertiser.myPeerID.displayName) got peer invitation from \(peerID.displayName). ACCEPTING")
        invitationHandler(true, selfSession)
    }
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError){
        print("Browser could not start browsing! Error: \(error)")
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID){
        print("browser \(browser.myPeerID.displayName) lost connection to: \(peerID.displayName)")
    }
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?){
        print("\(browser.myPeerID.displayName) found peer! Found peerID: \(peerID.displayName)")
        browserSession = MCSession(peer: testPeerID)
        browserSession.delegate = self
        browser.invitePeer(peerID, toSession: browserSession, withContext: nil, timeout: 30)
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?){
        NSLog("Finished receiving resource with name");
    }
    
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void){
        //NSLog("%@", "didFinishReceivingResourceWithName")
        certificateHandler(true)
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID){
        NSLog("%@", "didReceiveData: \(data)")
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID){
        NSLog("%@", "didReceiveStream")
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress){
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState){
        if(state == .NotConnected){
            print("Session ID: \(session.myPeerID.displayName), peer ID: \(peerID.displayName) changed state. State: Not connected")
        }
        else if(state == .Connecting){
            print("Session ID: \(session.myPeerID.displayName), peer ID: \(peerID.displayName) changed state. State: connecting...")
        }
        else if(state == .Connected){
            self.delegate.didConnect(peerID.displayName)
            print("Session ID: \(session.myPeerID.displayName), peer ID: \(peerID.displayName) changed state. State: CONNECTED")
        }
    }

}