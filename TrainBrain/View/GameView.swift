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
    
    var showClearPopup: Bool {
        print("쇼클리어팝업: \(GameManager.didClear)")
        return GameManager.didClear
    }
    
    @State private var timeRemaining: Int = GameManager.gameTime
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                OneButtonPopupView(
                    main: "You Made It!",
                    sub: "play another game!",
                    agreeAction: {
                        GameManager.didClear = false
                    }
                )
                .onAppear {
                    self.timer.upstream.connect().cancel()
                }
            } else if self.showTimeOverPopup {
                OneButtonPopupView(
                    main: "Time Over",
                    sub: "try again!",
                    agreeAction: {
                        self.showTimeOverPopup = false
                    }
                )
            }
        }
        .onReceive(timer) { time in
            print("타임: \(time)")
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                print("time over: \(self.timeRemaining)")
                self.timer.upstream.connect().cancel()
                self.showTimeOverPopup = true
            }
        }
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
            GameManager.numOfPairs = 5
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

struct CardView: View {
    let card: GameViewModel.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameViewModel()
        game.choose(game.cards.first!)
        return GameView(game: game)
    }
}

struct OneButtonPopupView: View {
    var main: String // 팝업에 들어갈 주요 내용 (큰 글씨) -> .ob17
    var sub: String // 팝업에 들어갈 부가 내용 (작은 글씨) -> .or15
    var agreeAction: (() -> Void) // 확인 버튼 눌렀을 때 동작
    
    init(main: String, sub: String, agreeAction: @escaping (() -> Void)) {
        self.main = main
        self.sub = sub
        self.agreeAction = agreeAction
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4)
  
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        VStack {
                            Spacer().frame(height: 25)

                            // 굵은 텍스트가 들어가는 HStack
                            HStack {
                                Spacer()
                                Text(main)
                                    .foregroundColor(Color.customGray)
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                                    .lineLimit(nil)
                                    .minimumScaleFactor(0.8)
                                Spacer()
                            }

                            Spacer().frame(height: 20)

                            // 작은 텍스트가 들어가는 HStack
                            HStack {
                                Spacer()
                                Text(sub)
                                    .font(.subheadline)
                                    .foregroundColor(Color.customGray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .minimumScaleFactor(0.8)
                                Spacer()
                            }

                            Spacer().frame(height: 30)

                            // 확인 버튼
                            Button(action: {
                                self.agreeAction()
                            }) {
                                VStack(spacing: 0) {
                                    Text("OK")
                                        .font(.headline)
                                        .frame(width: 230)
                                        .frame(height: 40)
                                        .foregroundColor(.white)
                                        .background(Color.customBlue)
                                        .cornerRadius(6.0)
                                }
                            }
                            
                            Spacer().frame(height: 25)
                        }
                        .frame(width: 280)
                        .frame(height: 220)
                        .background(Color.white)
                        .cornerRadius(6.0)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)

            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
