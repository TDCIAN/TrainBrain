//
//  GameManager.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/15.
//

import Foundation

class GameManager {
    static let shared = GameManager()
    
    // 카드 난이도
    static var gameLevel: Int {
        get {
            return UserDefaults.standard.integer(forKey: "gameLevel")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "gameLevel")
        }
    }
    
    // 카드 쌍 개수
    static var numOfPairs: Int {
        get {
            return UserDefaults.standard.integer(forKey: "numOfPairs")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "numOfPairs")
            self.didClear = (newValue == 0)
        }
    }
    
    // 게임 시간
    static var gameTime: Int {
        get {
            return UserDefaults.standard.integer(forKey: "gameTime")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "gameTime")
        }
    }
    
    // 게임 클리어
    static var didClear: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didClear")
        }
        set(newValue) {
            print("디드클리어: \(newValue)")
            UserDefaults.standard.set(newValue, forKey: "didClear")
        }
    }
    
    // 최고 기록
    static var bestRecord: Int {
        get {
            return UserDefaults.standard.integer(forKey: "bestRecord")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "bestRecord")
        }
    }
    
    static var recordDate: String {
        get {
            return UserDefaults.standard.string(forKey: "recordDate") ?? "2021.07.15"
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "recordDate")
        }
    }
}
