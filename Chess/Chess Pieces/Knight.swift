//
//  Knight.swift
//  Chess
//
//  Created by Jack Cousineau on 10/23/15.
//

import Cocoa

class Knight: ChessPiece {
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool) {
        
        let xChange = abs(startX - destinationX)
        let yChange = abs(startY - destinationY)        
        
        return((xChange == 1&&yChange == 2)||(xChange == 2&&yChange == 1))
    }

}
