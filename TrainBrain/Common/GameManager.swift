//
//  GameManager.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/15.
//

import Foundation

class GameManager {
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
            print("맨처음 디드클리어 상태: \(UserDefaults.standard.bool(forKey: "didClear"))")
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
}
