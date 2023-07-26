# TicTacToe Game Design Write-Up

This is a design write-up for a simple TicTacToe game implemented in Swift using SpriteKit. The game allows two players to take turns placing their marks (X or O) on a 3x3 board. The game detects when a player wins or when the game ends in a draw.

## Game Overview

The game is built using SpriteKit, a 2D game framework provided by Apple. The scene consists of a 3x3 grid for the TicTacToe board, and players take turns tapping on an empty cell to place their mark. The game detects winning combinations (rows, columns, and diagonals) and announces the winner when the game ends. If the board is full without a winner, the game ends in a draw.

## Scene Setup

The game scene is represented by the `GameScene` class, which inherits from `SKScene`. The scene contains the following elements:

1. **Board**: A 3x3 grid is drawn using `SKShapeNode` to represent the TicTacToe board.

2. **Title Label**: A label displaying "(: TicTacToe :)" is placed at the top of the screen.

3. **Player Mark Buttons**: Buttons for selecting the player's marks (X and O) are added to the scene.

4. **Scoreboard Label**: A label displays the current score for Player X and Player O.

5. **Player Turn Label**: A label indicates whose turn it is to play (X's Turn or O's Turn).

6. **Winning Line**: An optional shape node representing the line that connects the winning cells.

## Game Logic

### Board Representation

The game board is represented as a 2D array `board`, where each cell stores an integer value:

- `0`: Represents an empty cell.
- `1`: Represents Player X's mark (X).
- `2`: Represents Player O's mark (O).

### Player Turn Switching

The game starts with Player X, and `currentPlayer` keeps track of the current player's turn. The player's turn is indicated using the `playerTurnLabel`.

### Mark Placement

When a player taps on an empty cell, the game checks the cell's position and calculates the corresponding row and column. It then places the current player's mark (X or O) at that position on the board. If the move is valid, the turn switches to the other player.

### Winning Conditions

The game checks for winning conditions after each move. It looks for three identical marks in a row (horizontal, vertical, or diagonal). If a winning condition is met, the game displays an alert announcing the winner and updates the scoreboard.

### Draw Condition

If all cells are filled, and there is no winner, the game ends in a draw, and an alert is displayed.

### Resetting the Game

After a win or draw, the game can be reset by tapping the "OK" button on the alert. The board is cleared, and the turn switches back to Player X.

## Conclusion

This design write-up outlines the structure and logic of a TicTacToe game implemented using SpriteKit in Swift. The game provides a simple and enjoyable two-player experience, keeping track of wins and draws, and offering a visually appealing interface. The design can be extended and customized further to add features like an AI opponent, sound effects, or a more elaborate UI. Happy coding!
