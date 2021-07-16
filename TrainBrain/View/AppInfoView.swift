//
//  AppInfoView.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/16.
//

import SwiftUI

struct AppInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var showOpensource: Bool = false
    var appVersion: String {
        let currentVer = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        return "Version \(currentVer)"
    }
    
    var body: some View {
        VStack {
            
            Spacer().frame(height: 20)
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Spacer().frame(width: 20)
                    
                    Image(systemName: "arrow.backward")
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.customGray)
                    
                    Spacer()
                }
            })
            
            Spacer().frame(height: 10)
            
            VStack {
                HStack {
                    Text("App Info")
                        .padding(.leading, 10)
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .frame(height: 50)
                    Spacer()
                }
                .background(Color.customGray)
                
                HStack {
                    Text(appVersion)
                        .padding(.leading, 20)
                        .foregroundColor(Color.customGray)
                        .font(.subheadline)
                        .frame(height: 40)
                    Spacer()
                }
                
                Button(action: {
                    print("오픈소스 라이센스")
                    self.showOpensource.toggle()
                }, label: {
                    HStack {
                        Text("Opensource License")
                            .padding(.leading, 20)
                            .foregroundColor(Color.customGray)
                            .font(.subheadline)
                            .frame(height: 40)
                        Spacer()
                    }
                })
   
                Link(destination: URL(string: "https://github.com/TDCIAN/TrainBrainPrivacyPolicy/blob/main/PrivacyPolicy.md")!, label: {
                        HStack {
                            Text("Privacy Policy")
                                .padding(.leading, 20)
                                .foregroundColor(Color.customGray)
                                .font(.subheadline)
                                .frame(height: 40)
                            Spacer()
                        }
                    })
            }
            
            VStack {
                HStack {
                    Text("Contact")
                        .padding(.leading, 10)
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .frame(height: 50)
                    Spacer()
                }
                .background(Color.customGray)

                HStack {
                    Text("tdcian71@gmail.com")
                        .padding(.leading, 20)
                        .foregroundColor(Color.customGray)
                        .font(.subheadline)
                        .frame(height: 40)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: self.$showOpensource) {
            OpensourceView()
        }
        .navigationBarHidden(true)
    }
}
