//
//  Pawn.swift
//  Chess
//
//  Created by Jack Cousineau on 10/23/15.
//

import Cocoa

class Pawn: ChessPiece {
    
    var firstMove = true
    var justMadeDoubleStep = false
    
    var enPassantCallback: ((enemyX: Int, enemyY: Int)->())
    
    init(image: NSImage, color: PieceColor, enPassantEventHandler: ((enemyX: Int, enemyY: Int)->())){
        enPassantCallback = enPassantEventHandler
        super.init(image: image, color: color)
    }
    
    func canApplyEnPassant(targetX: Int, targetY: Int, board: [[BoardSpace]]) -> Bool{
        if let targetPawn = board[targetX][targetY].occupyingPiece{
            if(targetPawn.isKindOfClass(Pawn) && (targetPawn as! Pawn).justMadeDoubleStep && targetPawn.pieceColor != pieceColor){
                enPassantCallback(enemyX: targetX, enemyY: targetY)
                return true
            }
        }
        return false
    }
    
    override func isValidMove(startX: Int, startY: Int, destinationX: Int, destinationY: Int, board: [[BoardSpace]]) -> (Bool) {
        
        var maxYVariance = 1, maxXVariance = 0
        
        if let _ = board[destinationX][destinationY].occupyingPiece{ // Piece at destination
            if(startX == destinationX){
                maxXVariance--;
            }
            else{
                maxXVariance++
            }
        }
        
        let isWhite = pieceColor == PieceColor.White
        if isWhite && startY == 4{
            if(canApplyEnPassant(destinationX, targetY: destinationY - 1, board: board)){
                return true
            }
        }
        else if !isWhite && startY == 3{
            if(canApplyEnPassant(destinationX, targetY: destinationY + 1, board: board)){
                return true
            }
        }
        
        let xVariance = abs(destinationX - startX), yVariance = abs(destinationY - startY)
        
        if(firstMove){
            maxYVariance++
        }
        
        
        if xVariance <= maxXVariance && yVariance <= maxYVariance && ((!(xVariance == 1 && yVariance == 2) && ((isWhite && startY < destinationY) || (!isWhite && startY > destinationY))) || (maxYVariance == 2 && ((isWhite && board[destinationX][startY + 1].occupyingPiece != nil) || (!isWhite && board[destinationX][startY - 1].occupyingPiece != nil)))){
            
            if(yVariance == 2){
                justMadeDoubleStep = true
            }
            firstMove = false
            return true
        }
        
        return false
    }

}
