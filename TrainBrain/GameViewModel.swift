//
//  GameViewModel.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/13.
//

import SwiftUI

class GameViewModel: ObservableObject {
    typealias Card = GameModel<String>.Card
    
    private static let emojis: [String] = [
        "🚂", "🚀", "🚁", "🛺", "🚗",
        "🚙", "🚌", "🚎", "🏎", "🚓",
        "🚑", "🚒", "🚐", "🛻", "🚚",
        "🚛", "🚜", "🚔", "🚍", "🚘",
        "🚖", "🚡", "🚠", "🚟", "🚟"
    ]
    
    private static func createGame() -> GameModel<String> {
        // numberOfPairsOfCards = 매칭 시킬 수 있는 카드 쌍의 개수
        GameModel<String>(numberOfPairsOfCards: 8) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: GameModel<String> = createGame()
    
    var cards: Array<Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = GameViewModel.createGame()
    }
}
