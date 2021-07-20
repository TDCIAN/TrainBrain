//
//  GameView.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/13.
//

import SwiftUI

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var gameViewModel: GameViewModel
    
    @Namespace private var dealingNamespace
    
    @State private var showTimeOverPopup: Bool = false
    @State private var showClearPopup: Bool = false
    
    @State private var timeRemaining: Int = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var timeString: String {
        if self.timeRemaining > 0 {
            return "\(timeRemaining)"
        } else {
            return "Finished!"
        }
    }
    
    private var timerColor: Color {
        if self.timeRemaining > 10 {
            return Color.customBlue
        } else if self.timeRemaining <= 10 && self.timeRemaining > 0 {
            return Color.customRed
        } else {
            return Color.customGray
        }
    }
    
    private var clearMainString: String {
        let oldRecord = GameManager.bestRecord
        let newRecord = GameManager.earnedPoints
        
        if oldRecord < newRecord {
            GameManager.bestRecord = newRecord
            return "Record Breaking!"
        } else {
            return "You Made It!"
        }
    }
    
    private var clearSubString: String {
        let newRecord = GameManager.earnedPoints
        return "you got\n\(newRecord) points!"
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack {
                    HStack {
                        if self.timeRemaining > 0 {
                            Group {
                                Text("⏱")
                                    .font(.title)
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Text(timeString)
                                    .font(.title)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("⏱")
                                    .font(.title)
                                    .padding(.trailing, 10)
                            }
                        } else {
                            Text(timeString)
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 150, height: 45)
                    .background(
                        Capsule()
                            .fill(timerColor)
                    )
                    .padding(.top)
                    
                    AspectVGrid(items: gameViewModel.cards, aspectRatio: 2/3) { card in
                        if isUndealt(card) || card.isMatched && !card.isFaceUp {
                            Color.clear
                        } else {
                            CardView(card: card)
                                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                                .padding(4)
                                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                                .zIndex(zIndex(of: card))
                                .onTapGesture {
                                    withAnimation {
                                        gameViewModel.choose(card)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    .foregroundColor(CardConstraints.color)
                    .onAppear {
                        gameViewModel.restart()
                        for card in gameViewModel.cards {
                            withAnimation(dealAnimation(for: card)) {
                                deal(card)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                
                if self.showClearPopup {
                    TwoButtonPopupView(
                        type: PopupType.clear,
                        main: clearMainString,
                        sub: clearSubString,
                        selectNewGame: {
                            self.showClearPopup = false
                            self.handleSetNewGame()
                        },
                        selectAgain: {
                            self.handleRestart()
                            self.showClearPopup = false
                        }
                    )
                } else if self.showTimeOverPopup {
                    TwoButtonPopupView(
                        type: PopupType.timeOver,
                        main: "Time Over",
                        sub: "choose next step!",
                        selectNewGame: {
                            self.showTimeOverPopup = false
                            self.handleSetNewGame()
                        },
                        selectAgain: {
                            self.handleRestart()
                            self.showTimeOverPopup = false
                        }
                    )
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                self.timeRemaining = GameManager.gameTime
            }
            .onReceive(timer) { time in
                handleTimer()
            }
        }
        .navigationBarHidden(true)
    }
        
    private func handleTimer() {
        if self.timeRemaining > 0 {
            if GameManager.didClear {
                self.showClearPopup = true
                self.timer.upstream.connect().cancel()
            } else {
                self.timeRemaining -= 1
            }
        } else {
            self.timer.upstream.connect().cancel()
            self.showTimeOverPopup = true
        }
    }
    
    private func handleSetNewGame() {
        GameManager.didClear = false
        gameViewModel.restart()
        self.presentationMode.wrappedValue.dismiss()
    }
        
    private func handleRestart() {
        GameManager.didClear = false
        gameViewModel.restart()
        self.timeRemaining = GameManager.gameTime
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: GameViewModel.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: GameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: GameViewModel.Card) -> Animation {
        var delay = 0.0
        if let index = gameViewModel.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstraints.totalDealDuration / Double(gameViewModel.cards.count))
        }
        return Animation.easeInOut(duration: CardConstraints.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: GameViewModel.Card) -> Double {
        -Double(gameViewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private struct CardConstraints {
        static let color = Color.customBlue
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}
