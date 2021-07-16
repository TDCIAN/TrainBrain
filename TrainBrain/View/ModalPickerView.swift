//
//  ModalPickerView.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/16.
//

import SwiftUI

enum PickerType {
    case gameLevel
    case numOfCards
    case gameTime
}

struct ModalPickerView: View {
    @Binding var chosenValue: Int
    @Binding var pickerType: PickerType
    var selectAction: (() -> Void)

    @State var selectionList: [Int] = []
    
    private var gameLevelList: [Int] = [1, 2, 3, 4, 5]
    private var numberOfCards = Array(1...20)
    private var gameTimeList: [Int] = [30, 60, 90]
    
    init(chosenValue: Binding<Int>, pickerType: Binding<PickerType>, selectAction: @escaping (() -> Void)) {
        self._chosenValue = chosenValue
        self._pickerType = pickerType
        self.selectAction = selectAction
    }
    
    private var title: String {
        switch self.pickerType {
        case .gameLevel:
            return "GAME LEVEL"
        case .numOfCards:
            return "NUMBER OF CARDS"
        case .gameTime:
            return "GAME TIME(SECONDS)"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4)
                
                VStack {
                    Spacer()
                    
                    VStack {
                        Spacer().frame(height: 30)
                        
                        Text(title)
                            .foregroundColor(Color.customGray)
                            .font(.system(size: 24, weight: .bold))
                        
                        Spacer().frame(height: 10)
                        
                        Picker("What's up", selection: $chosenValue) {
                            ForEach(self.selectionList, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .frame(height: 150)
                        .labelsHidden()
                        
                        Spacer().frame(height: 10)
                        
                        Button(action: {
                            self.selectAction()
                        }) {
                            Text("SELECT \(chosenValue)")
                                .font(.system(size: 20, weight: .bold))
                               .frame(maxWidth: .infinity)
                               .frame(height: 50)
                               .foregroundColor(Color.customGray)
                               .contentShape(Rectangle())
                        }
                        .padding(.bottom, 30)
                    }
                    .frame(width: geometry.size.width)
                    .frame(height: 300)
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.vertical)
                }
            }
            .edgesIgnoringSafeArea(.vertical)
            .onAppear {
                self.setDefaultChosenValue()
                self.setSelectionList()
            }
        }
    }
    
    private func setDefaultChosenValue() {
        if pickerType == .gameLevel {
            self.chosenValue = 1
        } else if pickerType == .numOfCards {
            self.chosenValue = 10
        } else {
            self.chosenValue = 60
        }
    }
    
    private func setSelectionList() {
        if pickerType == .gameLevel {
            self.selectionList.append(contentsOf: self.gameLevelList)
        } else if pickerType == .numOfCards {
            self.selectionList.append(contentsOf: self.numberOfCards)
        } else {
            self.selectionList.append(contentsOf: self.gameTimeList)
        }
    }
}
