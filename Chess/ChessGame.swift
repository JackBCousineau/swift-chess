//
//  ChessGame.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//

import Cocoa

/**
 Simple enumeration to keep track of the type of game being played
 - HumanVsHuman
 - HumanVsComputer
 - ComputerVsComputer
*/
enum GameType{
    case HumanVsHuman
    case HumanVsComputer
    case ComputerVsComputer
}

/**
 The IconSet structure. Creates and holds each icon for each chess piece.
*/
struct IconSet {
    var whitePawn: NSImage!
    var whiteRook: NSImage!
    var whiteKnight: NSImage!
    var whiteBishop: NSImage!
    var whiteQueen: NSImage!
    var whiteKing: NSImage!
    
    var blackPawn: NSImage!
    var blackRook: NSImage!
    var blackKnight: NSImage!
    var blackBishop: NSImage!
    var blackQueen: NSImage!
    var blackKing: NSImage!
    
    init(iconSetName: String){
        whitePawn = NSImage(named: iconSetName + "_white_pawn")
        whiteRook = NSImage(named: iconSetName + "_white_rook")
        whiteKnight = NSImage(named: iconSetName + "_white_knight")
        whiteBishop = NSImage(named: iconSetName + "_white_bishop")
        whiteQueen = NSImage(named: iconSetName + "_white_queen")
        whiteKing = NSImage(named: iconSetName + "_white_king")
        
        blackPawn = NSImage(named: iconSetName + "_black_pawn")
        blackRook = NSImage(named: iconSetName + "_black_rook")
        blackKnight = NSImage(named: iconSetName + "_black_knight")
        blackBishop = NSImage(named: iconSetName + "_black_bishop")
        blackQueen = NSImage(named: iconSetName + "_black_queen")
        blackKing = NSImage(named: iconSetName + "_black_king")
    }
}

/**
 Holds a captured `ChessPiece` and the `NSImageView` that it's being displayed in.
*/
struct CapturedPieceImageView{
    var piece: ChessPiece!
    var imageView: NSImageView!
}

/**
 Completely encapsulates an instance of a chess game.
*/
class ChessGame{
    
    let gameWindow : NSWindow!
    let chessBoard : Board!
    let whitePlayerName: String!, blackPlayerName: String!
    
    let iconSet: IconSet!
    
    var playerTurn = PieceColor.White
    
    var whiteCapturedPieces = [CapturedPieceImageView](), blackCapturedPieces = [CapturedPieceImageView]()
    
    /**
     Displays the captured piece in the game's interface.
     
     - Parameter piece: The ChessPiece to display.
     */
    func displayCapturedPiece(piece: ChessPiece){
        
        var pieceArray : [CapturedPieceImageView]!
        
        // We decide which array to insert the piece into, based on the piece's color.
        if(piece.pieceColor == PieceColor.Black){
            pieceArray = whiteCapturedPieces
        }
        else{
            pieceArray = blackCapturedPieces
        }
        
        for i in 0...15{
            if(pieceArray[i].piece == nil){
                // Once we find the first available slot in pieceArray, we store the piece in that slot, and display the piece's icon.
                pieceArray[i].piece = piece
                pieceArray[i].imageView.image = piece.pieceImage
                return
            }
        }
    }

    /**
     The ChessGame class constructor.
     
     - Parameter gameType: The `GameType` of the game.
     - Parameter difficulty: The difficulty of the AI to be played against, if any. Currently has no effect.
     - Parameter whitePlayerName: The name of white side's player.
     - Parameter blackPlayerName: The name of black side's player.
     - Parameter iconSetName: The name of the `IconSet` to be used.
     */
    init(gameType: GameType, difficulty: Int!, whitePlayerName: String, blackPlayerName: String, iconSetName: String){
        self.blackPlayerName = blackPlayerName
        self.whitePlayerName = whitePlayerName
        
        // We rely on storyboard instantiation for each instance of a chess game. Here we grab the NSWindowController from the storyboard, and do a few more tweaks before the game starts.
        let windowController = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("ChessBoardWindowController") as! NSWindowController
        gameWindow = windowController.window
        gameWindow.title = whitePlayerName + " vs " + blackPlayerName + ", ft. John Cena"
        chessBoard = gameWindow.contentView?.subviews[6] as! Board
        
        // Here we programatically add the NSImageViews for the CapturedPieceImageView objects.
        var view = gameWindow.contentView, size = CGFloat(18), x = CGFloat(44), y = CGFloat(40)
        for i in 0...15{
            let whiteImageView = NSImageView(frame: NSMakeRect(x, y, size, size))
            view?.addSubview(whiteImageView)
            whiteCapturedPieces.append(CapturedPieceImageView(piece: nil, imageView: whiteImageView))
            
            let blackImageView = NSImageView(frame: NSMakeRect(x + 355, y, size, size))
            view?.addSubview(blackImageView)
            blackCapturedPieces.append(CapturedPieceImageView(piece: nil, imageView: blackImageView))
            
            x += size
            if(i == 7){
                y -= 20
                x = 44
            }
        }
        
        // Lastly, we create the IconSet, populate the chess board, and give values to a few more labels.
        iconSet = IconSet(iconSetName: iconSetName.lowercaseString)
        chessBoard.populateBoard(iconSet)
        chessBoard.currentPlayerTurnLabel.stringValue = whitePlayerName + "'s"
        chessBoard.whitePlayerLabel.stringValue = whitePlayerName + " - White"
        chessBoard.blackPlayerLabel.stringValue = blackPlayerName + " - Black"
        chessBoard.chessGame = self
        
        // And finally, we display the game window.
        windowController.showWindow(nil)
    }
    
    /**
     Changes which player's turn it is.
     */
    func newPlayerMove(){
        if(playerTurn == .White){
            playerTurn = .Black
            chessBoard.currentPlayerTurnLabel.stringValue = blackPlayerName + "'s"
        }
        else{
            playerTurn = .White
            chessBoard.currentPlayerTurnLabel.stringValue = whitePlayerName + "'s"
        }
    }

}