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
    
    var currentPlayer = 1
    var board = [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)
    let screenSize = UIScreen.main.bounds.size
    var playerTurnLabelText: SKLabelNode?
    var scoreboardLabel: SKLabelNode?
    
    var winningLine: SKShapeNode?
    
    var xNode: SKSpriteNode?
    var oNode: SKSpriteNode?
    
    var player1Score = 0
    var player2Score = 0
    

    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        scene?.backgroundColor = .cyan
        let screenSize = UIScreen.main.bounds.size
        let boardSize = CGSize(width: 320, height: 320)
        let boardPos = CGPoint(x: screenSize.width / 2.0 - boardSize.width / 2.0,
                               y: screenSize.height / 2.0 - boardSize.height / 2.0)
        let boardNode = SKShapeNode(rect: CGRect(origin: boardPos, size: boardSize), cornerRadius: 8.0)
        boardNode.fillColor = .clear
        boardNode.strokeColor = .clear
        boardNode.lineWidth = 3.0
        addChild(boardNode)
        
        let titleLabel = SKLabelNode(text: "(: TicTacToe :)")
        titleLabel.fontName = "HelveticaNeue-Bold"
        titleLabel.fontSize = 40.0
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.75)
        addChild(titleLabel)


        let lineLength = boardSize.width / 3.0
        let lineThickness: CGFloat = 3.0
        let lineOffset = lineThickness / 2.0

        for col in 1..<3 {
            let linePath = UIBezierPath()
            let startX = boardPos.x + CGFloat(col) * lineLength - lineOffset
            let startY = boardPos.y
            let endX = startX
            let endY = startY + boardSize.height
            linePath.move(to: CGPoint(x: startX, y: startY))
            linePath.addLine(to: CGPoint(x: endX, y: endY))
            let lineNode = SKShapeNode(path: linePath.cgPath)
            lineNode.strokeColor = .black
            lineNode.lineWidth = lineThickness
            addChild(lineNode)
        }

        for row in 1..<3 {
            let linePath = UIBezierPath()
            let startX = boardPos.x
            let startY = boardPos.y + CGFloat(row) * lineLength - lineOffset
            let endX = startX + boardSize.width
            let endY = startY
            linePath.move(to: CGPoint(x: startX, y: startY))
            linePath.addLine(to: CGPoint(x: endX, y: endY))
            let lineNode = SKShapeNode(path: linePath.cgPath)
            lineNode.strokeColor = .black
            lineNode.lineWidth = lineThickness
            addChild(lineNode)
        }
        
        if let xImg = UIImage(systemName: "xmark") {
            let xTexture = SKTexture(image: xImg)
            let xNode = SKSpriteNode(texture: xTexture)
            xNode.size = .init(width: 30, height: 30)
            xNode.position = .init(x: screenSize.width*0.35, y: 100)
            xNode.color = .white
            
            addChild(xNode)
        }
        
        if let oImg = UIImage(systemName: "circle") {
            let oTexture = SKTexture(image: oImg)
            let oNode = SKSpriteNode(texture: oTexture)
            oNode.size = .init(width: 30, height: 30)
            oNode.position = .init(x: screenSize.width*0.7, y: 100)
            oNode.color = .white
            
            addChild(oNode)
        }
        
        let scoreboardText = "Score: \(player1Score) - \(player2Score)"
        let scoreboardLabel = SKLabelNode(text: scoreboardText)
        scoreboardLabel.fontName = "HelveticaNeue-Bold"
        scoreboardLabel.fontSize = 20.0
        scoreboardLabel.fontColor = .black
        scoreboardLabel.position = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.15)
        addChild(scoreboardLabel)
        
        self.scoreboardLabel = scoreboardLabel
        
        self.isUserInteractionEnabled = true
        switchTurn()
        
        states?.enter(GameLoadState.self)
    }
    
    var boardPos: CGPoint {
        let screenSize = UIScreen.main.bounds.size
        let boardSize = CGSize(width: 320, height: 320)
        return CGPoint(x: screenSize.width / 2.0 - boardSize.width / 2.0,
                       y: screenSize.height / 2.0 - boardSize.height / 2.0)
    }

    func switchTurn() {
        let playerX = "X's Turn"
        let playerO = "O's Turn"
        
        playerTurnLabelText?.removeFromParent()
        
        var displayed = ""
        xNode?.color = currentPlayer == 1 ? .green : .black
        oNode?.color = currentPlayer == 2 ? .green : .black
        
        if currentPlayer == 1 {
            displayed = playerX
        } else {
            displayed = playerO
        }
        
        let label = SKLabelNode(text: displayed)
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 24.0
        label.fontColor = .black
        label.position = CGPoint(x: screenSize.width / 2, y: screenSize.height * 0.2)
        label.name = "playerTurnLabel"
        
        addChild(label)
        
        playerTurnLabelText = label
        
        let scoreText = "Score: \(player1Score) - \(player2Score)"
        scoreboardLabel?.text = scoreText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        let boxSize: CGFloat = 106.6
        
        let col = Int((location.x - boardPos.x) / boxSize)
        let row = Int((location.y - boardPos.y) / boxSize)
        
        if col >= 0 && col < 3 && row >= 0 && row < 3 {
            if currentPlayer == 1 {
                if addXNode(col: col, row: row) {
                    board[col][row] = currentPlayer
                    currentPlayer = 2
                    checkForWinner()
                    switchTurn()
                }
            } else {
                if addONode(col: col, row: row) {
                    board[col][row] = currentPlayer
                    currentPlayer = 1
                    checkForWinner()
                    switchTurn()
                }
            }

        }
    }


    func addXNode(col: Int, row: Int) -> Bool {
        if board[col][row] != 0 {
            return false
        }
        if let xImg = UIImage(systemName: "xmark") {
            let xTexture = SKTexture(image: xImg)
            let xNode = SKSpriteNode(texture: xTexture)
            xNode.size = CGSize(width: 30, height: 30)
            xNode.position = CGPoint(x: boardPos.x + CGFloat(col) * 120 + 40,
                                     y: boardPos.y + CGFloat(row) * 120 + 40)
            xNode.color = .black
            addChild(xNode)
        }
        return true
    }
    
    func addONode(col: Int, row: Int) -> Bool {
        if board[col][row] != 0 {
            return false
        }
        if let oImg = UIImage(systemName: "circle") {
            let oTexture = SKTexture(image: oImg)
            let oNode = SKSpriteNode(texture: oTexture)
            oNode.size = CGSize(width: 30, height: 30)
            oNode.position = CGPoint(x: boardPos.x + CGFloat(col) * 120 + 40,
                                     y: boardPos.y + CGFloat(row) * 120 + 40)
            oNode.color = .white
            addChild(oNode)
            
        }
        return true
    }
    
    func checkForWinner() {
        for i in 0..<3 {
            if board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][0] != 0 {
                showWinAlert(player: board[i][0], start: CGPoint(x: boardPos.x, y: boardPos.y + CGFloat(i) * 120 + 60), end: CGPoint(x: boardPos.x + 320, y: boardPos.y + CGFloat(i) * 120 + 60))
                resetGame()
                return
            }
        }
        
        for i in 0..<3 {
            if board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[0][i] != 0 {
                showWinAlert(player: board[0][i], start: CGPoint(x: boardPos.x + CGFloat(i) * 120 + 60, y: boardPos.y), end: CGPoint(x: boardPos.x + CGFloat(i) * 120 + 60, y: boardPos.y + 320))
                resetGame()
                return
            }
        }
        
        if board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != 0 {
            showWinAlert(player: board[0][0], start: CGPoint(x: boardPos.x, y: boardPos.y), end: CGPoint(x: boardPos.x + 320, y: boardPos.y + 320))
            resetGame()
            return
        }
        
        if board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != 0 {
            showWinAlert(player: board[0][2], start: CGPoint(x: boardPos.x, y: boardPos.y + 320), end: CGPoint(x: boardPos.x + 320, y: boardPos.y))
            resetGame()
            return
        }
        
        if isDraw() {
            showDrawAlert()
            resetGame()
            return
        }
    }
    
    func isDraw() -> Bool {
        for row in board {
            for cell in row {
                if cell == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func showWinAlert(player: Int, start: CGPoint, end: CGPoint) {


        let winner = player == 1 ? "X" : "O"

        let alert = UIAlertController(title: "Alert", message: "Player \(winner) wins!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if player == 1 {
                self?.player1Score += 1
            } else {
                self?.player2Score += 1
            }
            let scoreText = "Score: \(self?.player1Score ?? 0) - \(self?.player2Score ?? 0)"
            self?.scoreboardLabel?.text = scoreText
            self?.board = [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)
            self?.resetGame()
        }
        alert.addAction(okAction)

        if let viewController = view?.window?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }



    func showDrawAlert() {
        let alert = UIAlertController(title: "Alert", message: "Draw!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.resetGame()
            let scoreText = "Score: \(self?.player1Score ?? 0) - \(self?.player2Score ?? 0)"
            self?.scoreboardLabel?.text = scoreText
        }
        alert.addAction(okAction)
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func resetGame() {
        board = [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)
        currentPlayer = 1
        
        removeAllChildren()
        
        switchTurn()
        
        winningLine?.removeFromParent()
        sceneDidLoad()
    }
    
    func configureGameState() {
        let loadState = GameLoadState(scene: self)
        states = GKStateMachine(states: [loadState])
    }
}
