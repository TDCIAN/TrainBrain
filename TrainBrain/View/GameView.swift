//
//  GameView.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/13.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var game: GameViewModel
    
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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                timerView
                    .border(Color.red, width: 1)
                
                gameBody
                    .border(Color.green, width: 1)
            }
            
            if self.showClearPopup {
                TwoButtonPopupView(
                    main: "You Made It!",
                    sub: "choose next step!",
                    selectNewGame: {
                        self.showClearPopup = false
                    },
                    selectAgain: {
                        self.handleRestart()
                        self.showClearPopup = false
                    }
                )
            }
            if self.showTimeOverPopup {
                TwoButtonPopupView(
                    main: "Time Over",
                    sub: "choose next step!",
                    selectNewGame: {
                        self.showTimeOverPopup = false
                    },
                    selectAgain: {
                        self.handleRestart()
                        self.showTimeOverPopup = false
                    }
                )
            }
        }
        .onAppear {
            self.timeRemaining = GameManager.gameTime
        }
        .onReceive(timer) { time in
            print("타임: \(time)")
            handleTimer()
        }
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
            print("time over: \(self.timeRemaining)")
            self.timer.upstream.connect().cancel()
            self.showTimeOverPopup = true
        }
    }
    
    private func handleRestart() {
        game.restart()
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
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstraints.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstraints.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: GameViewModel.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var timerView: some View {
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
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
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
                            game.choose(card)
                        }
                    }
            }
        }
        .padding(.horizontal)
        .foregroundColor(CardConstraints.color)
        .onAppear {
            GameManager.gameTime = 15
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstraints.undealtWidth, height: CardConstraints.undealtHeight)
        .foregroundColor(CardConstraints.color)
        .onTapGesture {
            // "deal" cards
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }            
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
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
