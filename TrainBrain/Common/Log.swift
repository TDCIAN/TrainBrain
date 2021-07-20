//
//  Log.swift
//  TrainBrain
//
//  Created by JeongminKim on 2021/07/20.
//

import Foundation

func Log<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, line: Int = #line) {
    #if DEBUG
    let objectValue = object()
    var stringRepresentation: String = ""
    
    if let value = objectValue as? CustomStringConvertible {
        stringRepresentation = value.description
    }
    let fileURL = URL(fileURLWithPath: file).lastPathComponent
    let queue = Thread.isMainThread ? "[Main]" : "[Others]"
    print("\(Date()) - <\(queue) \(fileURL) \(function) [Line: \(line)] - \(stringRepresentation)")
    #endif
}
