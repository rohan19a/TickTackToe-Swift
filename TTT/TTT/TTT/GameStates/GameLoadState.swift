//
//  GameLoadState.swift
//  TTT
//
//  Created by Hyung Lee on 7/11/23.
//

import SpriteKit
import GameplayKit

class GameLoadState: GKState {
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        //now you have access to game scene from state
        self.scene = scene
        super.init()
    }
    

    override func didEnter(from previousState: GKState?) {
        //code entrance
        //you can add loading specific setup, logic in this state
        scene.currentPlayer = 1
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameLoadState.Type
    }

    override func willExit(to nextState: GKState) {
        // Clean up or perform any necessary actions when transitioning out of the game play state
    }
}
