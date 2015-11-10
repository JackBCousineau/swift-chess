//
//  ChessGame.swift
//  Chess
//
//  Created by Jack Cousineau on 10/14/15.
//

import Cocoa

enum GameType{
    case HumanVsHuman
    case HumanVsComputer
    case ComputerVsComputer
}

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

struct CapturedPieceImageView{
    var piece: ChessPiece!
    var imageView: NSImageView!
}

class ChessGame{
    
    let gameWindow : NSWindow!
    let chessBoard : Board!
    let whitePlayerName: String!, blackPlayerName: String!
    
    let iconSet: IconSet!
    
    var playerTurn = PieceColor.White
    
    var whiteCapturedPieces = [CapturedPieceImageView](), blackCapturedPieces = [CapturedPieceImageView]()
    
    func displayCapturedPiece(piece: ChessPiece){
        if(piece.pieceColor == PieceColor.Black){
            insertChessPieceIntoArray(piece, pieceArray: &whiteCapturedPieces)
        }
        else{
            insertChessPieceIntoArray(piece, pieceArray: &blackCapturedPieces)
        }
    }
    
    func insertChessPieceIntoArray(piece: ChessPiece, inout pieceArray: [CapturedPieceImageView]){
        for i in 0...15{
            if(pieceArray[i].piece == nil){
                pieceArray[i].piece = piece
                pieceArray[i].imageView.image = piece.pieceImage
                return
            }
        }
    }

    init(gameType: GameType, difficulty: Int!, whitePlayerName: String, blackPlayerName: String, iconSetName: String){
        self.blackPlayerName = blackPlayerName
        self.whitePlayerName = whitePlayerName
        
        let windowController = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateControllerWithIdentifier("ChessBoardWindowController") as! NSWindowController
        gameWindow = windowController.window
        gameWindow.title = whitePlayerName + " vs " + blackPlayerName + ", ft. John Cena"
        chessBoard = gameWindow.contentView?.subviews[6] as! Board
        
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
        
        iconSet = IconSet(iconSetName: iconSetName.lowercaseString)
        chessBoard.populateBoard(iconSet)
        chessBoard.currentPlayerTurnLabel.stringValue = whitePlayerName + "'s"
        chessBoard.whitePlayerLabel.stringValue = whitePlayerName + " - White"
        chessBoard.blackPlayerLabel.stringValue = blackPlayerName + " - Black"
        chessBoard.chessGame = self
        windowController.showWindow(nil)
    }
    
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