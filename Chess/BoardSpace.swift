//
//  BoardSpace.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//  Copyright © 2015 Jack Cousineau. All rights reserved.
//

import Cocoa

class BoardSpace: NSBox {
    
    var occupyingPiece: ChessPiece!
    var occupyingPieceImageView: NSImageView!
    var x: Int!
    var y: Int!
    var clickEventBlock: ((BoardSpace)->())?
    
    init(xPixels: Int, yPixels: Int, fillWhite: Bool, clickEventHandler: ((BoardSpace)->())?){
        x = (xPixels-2)/70
        y = (yPixels-2)/70
        super.init(frame: NSMakeRect(CGFloat(xPixels), CGFloat(yPixels), 71, 71))
        titlePosition = NSTitlePosition.NoTitle
        boxType = .Custom
        borderType = .NoBorder
        if(fillWhite){
            fillColor = NSColor.whiteColor()
        }
        else{
            fillColor = NSColor.grayColor()
        }
        clickEventBlock = clickEventHandler
    }
    
    func setPiece(chessPiece: ChessPiece){
        occupyingPiece = chessPiece
        if(occupyingPieceImageView == nil){
            occupyingPieceImageView = NSImageView(frame: NSMakeRect(-1, 0, 60, 60))
            contentView?.addSubview(occupyingPieceImageView)
        }
        occupyingPieceImageView.image = chessPiece.pieceImage
    }
    
    func clearPiece(){
        occupyingPieceImageView.removeFromSuperview()
        occupyingPiece = nil
        occupyingPieceImageView = nil
    }
    
    override func mouseDown(theEvent: NSEvent){
        clickEventBlock!(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
