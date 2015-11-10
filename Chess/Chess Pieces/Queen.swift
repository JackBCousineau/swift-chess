//
//  Queen.swift
//  Chess
//
//  Created by Jack Cousineau on 10/23/15.
//

import Cocoa

class Queen: ChessPiece {
    
    var takenOverPawnImage: NSImage!
    
    init(image: NSImage, pawnImage: NSImage!, color: PieceColor){
        super.init(image: image, color: color)
        takenOverPawnImage = pawnImage
    }
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool) {
        
        if(parseBishopMovement(startX, startY: startY, destinationX: destinationX, destinationY: destinationY, board: board)){
            return true
        }
        return parseRookMovement(startX, startY: startY, destinationX: destinationX, destinationY: destinationY, board: board)
    }

}
