//
//  OpensourceView.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/16.
//

import SwiftUI

struct OpensourceView: View {
    
    var body: some View {
        
        VStack {
            Spacer().frame(height: 30)
            
            Text("Opensource License")
                .font(.title)
                .foregroundColor(.customGray)
            
            Spacer().frame(height: 20)
            
            Group {
                HStack {
                    Text("SwiftLint")
                        .padding(.leading, 20)
                        .foregroundColor(Color.customGray)
                        .font(.headline)
                    Spacer()
                }
                
                HStack {
                    Text("https://github.com/realm/SwiftLint")
                        .padding(.leading, 20)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                    Spacer()
                }
                
                HStack {
                    Text("MIT License")
                        .padding(.leading, 20)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                    Spacer()
                }
            }
            
            Spacer()
        }
        
    }
}
