//
//  Color+Extension.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/15.
//

import SwiftUI

extension Color {
    init(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Double = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0, opacity: alpha)
    }
    
    static var customGray: Color { Color(90, 90, 90) }
    static var customRed: Color { Color(255, 93, 93) }
    static var customBlue: Color { Color(0, 174, 239) }
    static var backgroundBlue: Color { Color(29, 38, 163) }
    static var buttonBlue: Color { Color(6, 31, 128) }
}
