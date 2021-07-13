//
//  GameViewModel.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/13.
//

import SwiftUI

class GameViewModel: ObservableObject {
    static let emojis: [String] = [
        "🚂", "🚀", "🚁", "🛺", "🚗",
        "🚙", "🚌", "🚎", "🏎", "🚓",
        "🚑", "🚒", "🚐", "🛻", "🚚",
        "🚛", "🚜", "🚔", "🚍", "🚘",
        "🚖", "🚡", "🚠", "🚟", "🚟"
    ]
    
    static func createGame() -> GameModel<String> {
        // numberOfPairsOfCards = 매칭 시킬 수 있는 카드 쌍의 개수
        GameModel<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: GameModel<String> = createGame()
    
    var cards: Array<GameModel<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: GameModel<String>.Card) {
        model.choose(card)
    }
}
