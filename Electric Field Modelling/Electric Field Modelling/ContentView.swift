//
//  ContentView.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 17.11.2021.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var mainGameScene: SKScene = { (_ screenSize: CGSize) -> SKScene in
        let scene = MainGameScene(size: UIScreen.main.bounds.size)
        scene.size = CGSize(width: screenSize.width,
                            height: screenSize.height-70)
        return scene
    }(UIScreen.main.bounds.size)
    
    var body: some View {
        VStack(spacing: 0){
            SpriteView(scene: mainGameScene)
            ControlElements()
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}

struct ControlElements: View {
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.gray)
//            Button(action: {print("changed")})
//            {
//                Text("Show equipotential lines")
//            }
        }
        .frame(height: 70)
    }
}
