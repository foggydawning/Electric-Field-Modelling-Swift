//
//  ContentView.swift
//  Electric Field Modelling
//
//  Created by Илья Чуб on 17.11.2021.
//

import SwiftUI
import SpriteKit



struct ContentView: View {
    var mainGameScene: MainGameScene = .init(
        size: .init(width: UIScreen.main.bounds.size.width,
                    height: UIScreen.main.bounds.size.height-70)
    )
    
    var body: some View {
        VStack(spacing: 0){
            SpriteView(scene: mainGameScene, preferredFramesPerSecond: 60)
            ControlElements(mainGameScene: mainGameScene )
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
    let mainGameScene: MainGameScene
    var body: some View {
        ZStack{
            Rectangle().foregroundColor(.gray)
            Button(action: {},
                   label: {
                Text("Show equipotential lines")
                    .foregroundColor(.black)
                
            })
                .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ _ in
                                if !mainGameScene.isPaused {
                                    mainGameScene.getEquipotential()
                                }
                                mainGameScene.isPaused = true
                                
                            })
                            
                            .onEnded({ _ in
                                mainGameScene.isPaused = false
                                mainGameScene.afterPaused()
                            })
                        )
        }
        .frame(height: 70)
    }
}
