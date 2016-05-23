//
//  Board.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//

import Cocoa

/**
 The `Board` class encapsulates the actual "visual" portion of a ChessGame instance.
 It can be thought of as the physical playing board in a real-life game of chess.
 */
class Board: NSView{
    
    /**
     The `NSTextField` that displays the name of whomever's turn it is.
     */
    @IBOutlet var currentPlayerTurnLabel: NSTextField!
    
    /**
     The `NSTextField` that says "turn".
     */
    @IBOutlet var turnLabel: NSTextField!
    
    /**
     The `NSTextField` that displays the white player's name.
     */
    @IBOutlet var whitePlayerLabel: NSTextField!
    
    /**
     The `NSTextField` that displays the white player's name.
     */
    @IBOutlet var blackPlayerLabel: NSTextField!
    
    /**
     The game's corresponding `ChessGame` instance
     */
    var chessGame: ChessGame!
    
    /**
     2D array to hold the game's `BoardSpace`s in a grid pattern.
     Note that the coordinates start from the bottom-left, at 0,0.
     */
    var boardSpaces = [[BoardSpace]]()
    
    /**
     The `BoardSpace` currently highlighted.
     */
    var highlightedSpace: BoardSpace!
    
    /**
     The normal background `NSColor` of the `BoardSpace` that is currently highlighted.
     Needed to restore the `BoardSpace`'s color back to normal after its highlight is removed.
     */
    var highlightedSpaceColor: NSColor!
    
    
    /**
     The `ChessPiece` that moved during the last turn. Used to detect the conditions for an en passant move.
     */
    var lastPieceMoved: ChessPiece!
    
    /**
     Indicates whether the game has finished.
     */
    var gameOver = false
    
    /**
     Our En passant callback code block. Also known as a "callback function", and functionally equivalent
     to function pointers, these are basically blocks of code wrapped up to act like a normal variable. They provide an easy
     way to interact between classes, and are much more flexible than other methods, such as delegation or notification usage.
     In this case, it's being used to handle the extra board management required when a pawn destroys another pawn using en passant.
     
     - Parameter enemyX: The x-coordinate of the enemy pawn
     - Parameter enemyY: The y-coordinate of the enemy pawn
    */
    var enPassantBlock: ((enemyX: Int, enemyY: Int)->())!
    
    /**
     Highlights a `BoardSpace`.
     
     - Parameter space: The `BoardSpace` to highlight.
     */
    func highlightPiece(space: BoardSpace){
        if let piece = highlightedSpace{
            piece.fillColor = highlightedSpaceColor
        }
        highlightedSpace = space
        highlightedSpaceColor = space.fillColor
        space.fillColor = NSColor.yellowColor()
    }
    
    /**
     Removes highlighting from the currently-highlighted `BoardSpace`.
     */
    func clearHighlight(){
        if highlightedSpace != nil{
            highlightedSpace.fillColor = highlightedSpaceColor
        }
        highlightedSpace = nil
        highlightedSpaceColor = nil
    }
    
    /**
     The constructor for the `Board` class. Called automatically when instantiated from the storyboard.
     */
    required init?(coder: NSCoder){
        super.init(coder: coder)
        
        // Here we define the callback block for En passant moves.
        enPassantBlock = {
            (x: Int, y: Int) in
            let capturedPiece = self.boardSpaces[x][y].occupyingPiece
            self.boardSpaces[x][y].clearPiece()
            self.chessGame.displayCapturedPiece(capturedPiece)
        }
        
        var whiteSpace = false
        
        // The sole purpose of this column loop, and the row loop two lines later, is to populate the empty board with BoardSpaces. However, a
        // clickEventHandler block must be passed to the BoardSpace constructor; declaring the block here negates the need to hold a reference
        // to it, but has the unfortunate side effect of greatly ballooning the size of this section of otherwise-unrelated code.
        for column in 0 ..< 8 {
            var columnSection = [BoardSpace]()
            for row in 0 ..< 8 {
                let boardSpace = BoardSpace(xPixels: column*70+2, yPixels: row*70+2, fillWhite: whiteSpace){
                    
                    // Everything between this line and line 202 is the definition of the clickEventHandler callback.
                    space in
                    
                    // We immediately end the function if the game is over, as we want to ignore all clicks on any BoardSpace.
                    if(self.gameOver){
                        return
                    }
                    
                    let occupant = space.occupyingPiece
                    var occupantIsAlly = false
                    if occupant != nil && occupant.pieceColor == self.chessGame.playerTurn{
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
                                if !isWhite {
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
                                    if occupant.isKindOfClass(King){
                                        if self.chessGame.playerTurn == PieceColor.White{
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
                            if self.lastPieceMoved != nil && self.lastPieceMoved.isKindOfClass(Pawn){
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
                    
                    else if occupantIsAlly{
                        self.highlightPiece(space)
                        return
                    }
                    self.clearHighlight()
                } // End of clickEventHandler.
                addSubview(boardSpace)
                columnSection.append(boardSpace)
                whiteSpace = !whiteSpace
            }
            boardSpaces.append(columnSection)
            whiteSpace = !whiteSpace
        }
    }
    
    /**
     Places all pieces on the `Board`.
     
     - Parameter iconSet: The `IconSet` to populate with.
     */
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
}
