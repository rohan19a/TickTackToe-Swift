#  <#Title#>

//
//  GameScene.swift
//  TTT
//
//  Created by Hyung Lee on 7/11/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var states: GKStateMachine?
    
    var currentPlayer = 0
    var board = [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)

    
    override func sceneDidLoad() {
        //first entry to the scene. you can add node to the screen to represent visual element
        //more info on nodes below
        //https://developer.apple.com/documentation/spritekit/skspritenode/getting_started_with_sprite_nodes
        scene?.backgroundColor = .white
        let screenSize = UIScreen.main.bounds.size
        let boardSize = CGSize(width: 320, height: 320)
        let boardPos = CGPoint(x: screenSize.width / 2.0 - boardSize.width / 2.0,
                               y: screenSize.height / 2.0 - boardSize.height / 2.0)
        let boardNode = SKShapeNode(rect: .init(origin: boardPos,
                                                size: boardSize), cornerRadius: 8.0)
        boardNode.scene?.anchorPoint = .init(x: 0.5, y: 0.5)
        boardNode.fillColor = .clear
        boardNode.strokeColor = .black
        boardNode.lineWidth = 3.0
        addChild(boardNode)
        
        //you can also configure states that application can get into
        configureGameState()

        //add text stating which player's turn it is
        let playerTurnLabel = SKLabelNode(text: "X's turn")
        playerTurnLabel.fontName = "HelveticaNeue-Bold"
        playerTurnLabel.fontSize = 24.0
        playerTurnLabel.fontColor = .black
        playerTurnLabel.position = .init(x: screenSize.width/2, y: screenSize.width*0.45)
        addChild(playerTurnLabel)
        
        
        //this is example of how you can add node on the scene
        
        if let xImg = UIImage(systemName: "xmark") {
            let xTexture = SKTexture(image: xImg)
            let xNode = SKSpriteNode(texture: xTexture)
            //just to show how to add a node on the board
            xNode.size = .init(width: 30, height: 30)
            xNode.position = .init(x: screenSize.width*0.35, y: 100)
            xNode.color = .white
            
            addChild(xNode)
        }
        


        if let oImg = UIImage(systemName: "circle") {
            let oTexture = SKTexture(image: oImg)
            let oNode = SKSpriteNode(texture: oTexture)
            //just to show how to add a node on the board
            oNode.size = .init(width: 30, height: 30)
            oNode.position = .init(x: screenSize.width*0.7, y: 100)
            oNode.color = .white
            
            addChild(oNode)
        }
        
        let gridSize = boardSize
                                         
        for row in 0..<3 {
          for col in 0..<3 {
            let rect = CGRect(origin: CGPoint(x: boardPos.x + CGFloat(col) * 80,
                                              y: boardPos.y + CGFloat(row) * 80),
                              size: CGSize(width: 80, height: 80))
            let cell = SKShapeNode(rect: rect, cornerRadius: 10)
            cell.fillColor = .clear
            cell.strokeColor = .black
            addChild(cell)
          }
        }
        
        // Add tap handler
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view?.addGestureRecognizer(tapHandler)

        states?.enter(GameLoadState.self)

    }
    
    func addXNode(col: Int, row: Int) {
        if let xImg = UIImage(systemName: "xmark") {
            let xTexture = SKTexture(image: xImg)
            let xNode = SKSpriteNode(texture: xTexture)
            xNode.size = CGSize(width: 30, height: 30)
            xNode.position = CGPoint(x: CGFloat(col) * frame.width / 3 + frame.width / 6,
                                     y: CGFloat(row) * frame.height / 3 + frame.height / 6)
            xNode.color = .white
            addChild(xNode)
        }
    }

    func addONode(col: Int, row: Int) {
        if let oImg = UIImage(systemName: "circle") {
            let oTexture = SKTexture(image: oImg)
            let oNode = SKSpriteNode(texture: oTexture)
            oNode.size = CGSize(width: 30, height: 30)
            oNode.position = CGPoint(x: CGFloat(col) * frame.width / 3 + frame.width / 6,
                                     y: CGFloat(row) * frame.height / 3 + frame.height / 6)
            oNode.color = .white
            addChild(oNode)
        }
    }

    
    @objc func takeTurn(gesture: UITapGestureRecognizer) {
        
        // Get row/col from tap location
        let location = gesture.location(in: view)
        let col = Int(location.x / (frame.width / 3))
        let row = Int(location.y / (frame.height / 3))
        
        // Make sure space is empty
        if board[row][col] == 0 {
            
            // Draw X or O
            if currentPlayer == 1 {
                addONode(col: col, row: row)  // Pass col and row as arguments
                board[row][col] = 1
            } else {
                addXNode(col: col, row: row)  // Pass col and row as arguments
                board[row][col] = 2
            }
            currentPlayer = currentPlayer == 1 ? 2 : 1
            
            // Check for winner
            print(board)
            checkForWinner()
        }
    }
    
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {

      // Get tap location in view
      let location = tap.location(in: view)
      
      // Convert to scene coordinates
      let scenePoint = scene!.convertPoint(fromView: location)

      // Calculate grid coordinates
      let col = Int(scenePoint.x / 80)
      let row = Int(scenePoint.y / 80)

      print("Tapped row: \(row), col: \(col)")

    }

        
    func checkForWinner() {

      // Check rows
      for i in 0..<3 {
        if board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != 0 {
          showWinAlert(player: board[i][0])
          return
        }
      }

      // Check columns
      for i in 0..<3 {
        if board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != 0 {
          showWinAlert(player: board[0][i])
          return
        }
      }

      // Check diagonals
      if board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != 0 {
        showWinAlert(player: board[0][0])
        return
      }

      if board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != 0 {
        showWinAlert(player: board[0][2])
        return
      }

      // Check for draw
      if isBoardFull() {
        showDrawAlert()
        return
      }

    }

    func isBoardFull() -> Bool {
      for row in board {
        for value in row {
          if value == 0 {
            return false
          }
        }
      }

      return true
    }
    
    func showWinAlert(player: Int) {
        let alert = UIAlertController(title: "Alert Title", message: "Player \(player) wins!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Handle OK button action
        }
        alert.addAction(okAction)
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func showDrawAlert() {
        let alert = UIAlertController(title: "Alert Title", message: "It's a draw!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Handle OK button action
        }
        alert.addAction(okAction)
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func placeItem(row: Int, col: Int) {
        
        
    }
    
    func configureGameState() {
        //more information on how state machine works
        //https://developer.apple.com/library/archive/documentation/General/Conceptual/GameplayKit_Guide/StateMachine.html#//apple_ref/doc/uid/TP40015172-CH7
    
        
        
        states = GKStateMachine(states: [
            GameLoadState(scene: self)
        ])
    }
    
}
