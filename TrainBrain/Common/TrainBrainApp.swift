//
//  TrainBrainApp.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/13.
//

import SwiftUI

@main
struct TrainBrainApp: App {
    private let game = GameViewModel()
    var body: some Scene {
        WindowGroup {
            GameView(game: game)
        }
    }
}
