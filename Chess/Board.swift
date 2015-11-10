//
//  Board.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//

import Cocoa

class Board: NSView{
    
    @IBOutlet var currentPlayerTurnLabel: NSTextField!
    @IBOutlet var turnLabel: NSTextField!
    @IBOutlet var whitePlayerLabel: NSTextField!
    @IBOutlet var blackPlayerLabel: NSTextField!
    
    var chessGame: ChessGame!
    
    var boardSpaces = [[BoardSpace]]()
    
    var highlightedSpace: BoardSpace!
    var highlightedSpaceColor: NSColor!
    
    var lastPieceMoved: ChessPiece!
    
    var gameOver = false
    
    var enPassantBlock: ((enemyX: Int, enemyY: Int)->())!
    
    func highlightPiece(space: BoardSpace){
        if let piece = highlightedSpace{
            piece.fillColor = highlightedSpaceColor
        }
        highlightedSpace = space
        highlightedSpaceColor = space.fillColor
        space.fillColor = NSColor.yellowColor()
    }
    
    func clearHighlight(){
        if(highlightedSpace != nil){
            highlightedSpace.fillColor = highlightedSpaceColor
        }
        highlightedSpace = nil
        highlightedSpaceColor = nil
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        
        enPassantBlock = {
            (x: Int, y: Int) in
            let capturedPiece = self.boardSpaces[x][y].occupyingPiece
            self.boardSpaces[x][y].clearPiece()
            self.chessGame.displayCapturedPiece(capturedPiece)
        }
        
        var whiteSpace = false
        
        
        for(var column = 0; column < 8; column++){
            var columnSection = [BoardSpace]()
            for(var row = 0; row < 8; row++){
                let boardSpace = BoardSpace(xPixels: column*70+2, yPixels: row*70+2, fillWhite: whiteSpace){
                    space in
                    
                    if(self.gameOver){
                        return
                    }
                    
                    let occupant = space.occupyingPiece
                    var occupantIsAlly = false//!(occupant != nil && occupant.pieceColor == self.chessGame.playerTurn)
                    if(occupant != nil && occupant.pieceColor == self.chessGame.playerTurn){
                        occupantIsAlly = true
                    }
                    
                    if let highlightedSpace = self.highlightedSpace, highlightedPiece = self.highlightedSpace!.occupyingPiece{ // A piece is already highlighted
                        if highlightedSpace.x == space.x && highlightedSpace.y == space.y { // The highlighted piece is clicked
                            self.clearHighlight()
                            return
                        }
                        if !occupantIsAlly && highlightedPiece.isValidMove(highlightedSpace.x, startY: highlightedSpace.y, destinationX: space.x, destinationY: space.y, board: self.boardSpaces){
                            space.setPiece(highlightedPiece)
                            highlightedSpace.clearPiece()
                            
                            let isWhite = highlightedPiece.pieceColor == PieceColor.White
                            
                            if highlightedPiece.isKindOfClass(Pawn) && (isWhite && space.y == 7 || !isWhite && space.y == 0) {
                                var queenImage = self.chessGame.iconSet.whiteQueen
                                if(!isWhite){
                                    queenImage = self.chessGame.iconSet.blackQueen
                                }
                                space.setPiece(Queen(image: queenImage, pawnImage: highlightedPiece.pieceImage, color: .White))
                            }
                            
                            if occupant != nil{ // An enemy has been destroyed
                                if occupant.isKindOfClass(Queen) && (occupant as! Queen).takenOverPawnImage != nil{
                                    self.chessGame.displayCapturedPiece(Pawn(image: (occupant as! Queen).takenOverPawnImage, color: .White, enPassantEventHandler: self.enPassantBlock))
                                }
                                else{
                                    self.chessGame.displayCapturedPiece(occupant)
                                    if(occupant.isKindOfClass(King)){
                                        if(self.chessGame.playerTurn == PieceColor.White){
                                            self.currentPlayerTurnLabel.stringValue = self.chessGame.whitePlayerName
                                        }
                                        else{
                                            self.currentPlayerTurnLabel.stringValue = self.chessGame.blackPlayerName
                                        }
                                        self.turnLabel.stringValue = "wins!"
                                        self.chessGame.gameWindow.title += " - (\(self.currentPlayerTurnLabel.stringValue) wins!)"
                                        self.gameOver = true
                                        self.clearHighlight()
                                        return
                                    }
                                }
                            }
                            if(self.lastPieceMoved != nil && self.lastPieceMoved.isKindOfClass(Pawn)){
                                (self.lastPieceMoved as! Pawn).justMadeDoubleStep = false
                            }
                            self.lastPieceMoved = space.occupyingPiece
                            self.chessGame.newPlayerMove()
                        }
                        else{
                            if occupantIsAlly{
                                self.clearHighlight()
                                self.highlightPiece(space)
                                return
                            }
                        }
                    }
                    
                    else if(occupantIsAlly){
                        self.highlightPiece(space)
                        return
                    }
                    self.clearHighlight()
                }
                addSubview(boardSpace)
                columnSection.append(boardSpace)
                whiteSpace = !whiteSpace
            }
            boardSpaces.append(columnSection)
            whiteSpace = !whiteSpace
        }
    }
    
    func populateBoard(iconSet: IconSet){
        for i in 0...7{
            boardSpaces[i][1].setPiece(Pawn(image: iconSet.whitePawn, color: .White, enPassantEventHandler: enPassantBlock))
        }
        boardSpaces[0][0].setPiece(Rook(image: iconSet.whiteRook, color: .White))
        boardSpaces[1][0].setPiece(Knight(image: iconSet.whiteKnight, color: .White))
        boardSpaces[2][0].setPiece(Bishop(image: iconSet.whiteBishop, color: .White))
        boardSpaces[3][0].setPiece(Queen(image: iconSet.whiteQueen, pawnImage: nil, color: .White))
        boardSpaces[4][0].setPiece(King(image: iconSet.whiteKing, color: .White))
        boardSpaces[5][0].setPiece(Bishop(image: iconSet.whiteBishop, color: .White))
        boardSpaces[6][0].setPiece(Knight(image: iconSet.whiteKnight, color: .White))
        boardSpaces[7][0].setPiece(Rook(image: iconSet.whiteRook, color: .White))
        
        for i in 0...7{
            boardSpaces[i][6].setPiece(Pawn(image: iconSet.blackPawn, color: .Black, enPassantEventHandler: enPassantBlock))
        }
        boardSpaces[0][7].setPiece(Rook(image: iconSet.blackRook, color: .Black))
        boardSpaces[1][7].setPiece(Knight(image: iconSet.blackKnight, color: .Black))
        boardSpaces[2][7].setPiece(Bishop(image: iconSet.blackBishop, color: .Black))
        boardSpaces[3][7].setPiece(Queen(image: iconSet.blackQueen, pawnImage: nil, color: .Black))
        boardSpaces[4][7].setPiece(King(image: iconSet.blackKing, color: .Black))
        boardSpaces[5][7].setPiece(Bishop(image: iconSet.blackBishop, color: .Black))
        boardSpaces[6][7].setPiece(Knight(image: iconSet.blackKnight, color: .Black))
        boardSpaces[7][7].setPiece(Rook(image: iconSet.blackRook, color: .Black))
    }
    
    func getColumnCharacter(column: Int) -> Character{
        switch column{
        case 1:
            return "A"
        case 2:
            return "B"
        case 3:
            return "C"
        case 4:
            return "D"
        case 5:
            return "E"
        case 6:
            return "F"
        case 7:
            return "G"
        default:
            return "H"
        }
    }
    
}
