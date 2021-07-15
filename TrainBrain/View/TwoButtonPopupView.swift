//
//  TwoButtonPopupView.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/15.
//

import SwiftUI

struct TwoButtonPopupView: View {
    var main: String
    var sub: String
    var selectNewGame: (() -> Void)
    var selectAgain: (() -> Void)
    
    init(main: String, sub: String, selectNewGame: @escaping (() -> Void), selectAgain: @escaping (() -> Void)) {
        self.main = main
        self.sub = sub
        self.selectNewGame = selectNewGame
        self.selectAgain = selectAgain
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4)
                
                VStack {
                    HStack {
                        VStack(alignment: .center, spacing: 0) {
                            
                            Spacer().frame(height: 40)
                            
                            HStack {
                                Spacer()
                                Text(main)
                                    .foregroundColor(Color.customGray)
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                                    .lineLimit(nil)
                                Spacer()
                            }

                            Spacer().frame(height: 12)

                            HStack {
                                Spacer()
                                Text(sub)
                                    .font(.subheadline)
                                    .foregroundColor(Color.customGray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                Spacer()
                            }

                            Spacer().frame(height: 30)

                            HStack {
                                Button(action: {
                                    self.selectNewGame()
                                }) {
                                    VStack(spacing: 0) {
                                        Text("Set New")
                                            .font(.headline)
                                            .frame(width: 110)
                                            .frame(height: 32)
                                            .foregroundColor(.white)
                                            .background(Color.customBlue)
                                            .cornerRadius(6.0)
                                    }
                                }
                                
                                Spacer().frame(width: 8)
                                
                                // 확인 버튼
                                Button(action: {
                                    self.selectAgain()
                                }) {
                                    VStack(spacing: 0) {
                                        Text("Try Again")
                                            .font(.headline)
                                            .frame(width: 110)
                                            .frame(height: 32)
                                            .foregroundColor(.white)
                                            .background(Color.customGray)
                                            .cornerRadius(6.0)
                                    }
                                }
                            }
                            
                            Spacer().frame(height: 30)
                        }
                        .frame(width: 290)
                        .frame(height: 200)
                        .background(Color.white)
                        .cornerRadius(6.0)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)

            }
            
        }
    }
}
