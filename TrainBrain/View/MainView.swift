//
//  MainView.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/15.
//

import SwiftUI

struct MainView: View {
    private var gameLevel: String {
        if GameManager.gameLevel == 0 {
            GameManager.gameLevel = 1
        }
        return "(1) Game Level : \(GameManager.gameLevel)"
    }
    
    private var numOfCard: String {
        if GameManager.numOfPairs == 0 {
            GameManager.numOfPairs = 10
        }
        return "(2) Number of Card : \(GameManager.numOfPairs)"
    }
    
    private var gameTime: String {
        if GameManager.gameTime == 0 {
            GameManager.gameTime = 60
        }
        return "(3) Game Time : \(GameManager.gameTime)"
    }
    
    private var matchingPoint: String {
        return "you can get \(GameManager.earnedPoints) points now!"
    }
    
    @State var bestRecord: String = "No Record"
    
    @State private var showPicker: Bool = false
    @State private var pickerType: PickerType = .gameLevel
    @State private var chosenValue: Int = -1
    
    private let gameViewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Color("LaunchPadColor")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer().frame(height: geometry.size.height * 0.125)
                        
                        Text("Carder Garden")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(Color.white)
                        
                        Group {
                            Spacer().frame(height: geometry.size.height * 0.07)

                            HStack {
                                Spacer()
                                Text("SET NEW GAME!")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                            }
                            
                            Spacer().frame(height: 15)
                            
                            VStack {
                                Spacer().frame(height: 15)
                                
                                Button(action: {
                                    self.pickerType = .gameLevel
                                    self.showPicker = true
                                }, label: {
                                    HStack {
                                        Text(gameLevel)
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 30)
                                            .font(.system(size: 20, weight: .bold))
                                        Spacer()
                                    }
                                })
                                
                                Spacer().frame(height: 20)
                                
                                Button(action: {
                                    self.pickerType = .numOfCards
                                    self.showPicker = true
                                }, label: {
                                    HStack {
                                        Text(numOfCard)
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 30)
                                            .font(.system(size: 20, weight: .bold))
                                        Spacer()
                                    }
                                })
                                
                                Spacer().frame(height: 20)
                                
                                Button(action: {
                                    self.pickerType = .gameTime
                                    self.showPicker = true
                                }, label: {
                                    HStack {
                                        Text(gameTime)
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 30)
                                            .font(.system(size: 20, weight: .bold))
                                        Spacer()
                                    }
                                })
                                
                                Spacer().frame(height: 15)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white, lineWidth: 3)
                            )
                            .frame(width: geometry.size.width - 60)
                            
                            Spacer().frame(height: 30)
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Text(matchingPoint)
                                        .foregroundColor(Color.white)
                                        .padding(.leading)
                                        .font(.system(size: 18, weight: .bold))
                                    Spacer()
                                }
                            }
                            
                        }
                        .frame(width: geometry.size.width)
                        
                        Spacer().frame(height: 20)
                        
                        VStack {
                            HStack {
                                Spacer()
                                Text("Best Record")
                                    .foregroundColor(Color.white)
                                    .padding(.leading)
                                    .font(.system(size: 15, weight: .bold))
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                Text(bestRecord)
                                    .foregroundColor(Color.white)
                                    .padding(.leading)
                                    .font(.system(size: 15, weight: .bold))
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: GameView(gameViewModel: gameViewModel)) {
                            HStack {
                                Spacer()
                                Text("START GAME")
                                    .frame(height: 60)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                            }
                            .background(Color.buttonBlue)
                            .cornerRadius(6)
                            .frame(width: geometry.size.width - 60)
                        }
                        
                        Spacer().frame(height: geometry.size.height * 0.05)
                        
                        NavigationLink(
                            destination: AppInfoView(),
                            label: {
                                HStack {
                                    Spacer()
                                    Text("APP INFO")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 15, weight: .bold))
                                    Spacer()
                                }
                            }
                        )
                        Spacer().frame(height: geometry.size.height * 0.05)
                    }
                    
                    if showPicker {
                        ModalPickerView(
                            chosenValue: self.$chosenValue,
                            pickerType: self.$pickerType,
                            selectAction: {
                                self.handleChosenValue(type: self.pickerType, value: self.chosenValue)
                                self.showPicker = false
                            }
                        )
                    }
                } // ZStack의 끝
                .navigationBarHidden(true)
                .onAppear {
                    GameManager.didClear = false
                    self.setBestRecord()
                }
            }
        }
    }
    
    private func handleChosenValue(type: PickerType, value: Int) {
        if type == .gameLevel {
            GameManager.gameLevel = value
        } else if type == .numOfCards {
            GameManager.numOfPairs = value
        } else {
            GameManager.gameTime = value
        }
    }
    
    private func setBestRecord() {
        if GameManager.bestRecord == 0 {
            self.bestRecord = "No Record"
        } else {
            self.bestRecord = "\(GameManager.bestRecord)"
        }
    }
}
