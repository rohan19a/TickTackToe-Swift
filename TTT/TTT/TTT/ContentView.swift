//
//  ContentView.swift
//  TTT
//
//  Created by Hyung Lee on 7/11/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SpriteView(scene: GameScene(size: proxy.size))
            }
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
