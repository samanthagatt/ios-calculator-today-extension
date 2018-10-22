//
//  DigitAccumulator.swift
//  RPN Calculator
//
//  Created by Samantha Gatt on 9/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

public struct DigitAccumulator {
    public init() {}
    
    public enum Digit: Equatable {
        case decimalPoint
        // an associated value of Int
        // bug: any size of int even though you only want 0-9
        case number(Int)
    }
    
    public enum DigitAccumulatorError: Error {
        case extraDecimalPoint
        case invalidDigitNumberValue
    }
    
    private var digits: [Digit] = []
    
    public mutating func add(digit: Digit) throws {
        switch digit {
        case .decimalPoint:
            if digits.contains(.decimalPoint) {
                throw DigitAccumulatorError.extraDecimalPoint
            }
            digits.append(digit)
        case .number(let value):
            if value < 0 || value > 9 {
                throw DigitAccumulatorError.invalidDigitNumberValue
            }
        }
        digits.append(digit)
    }
    
    public mutating func clear() {
        digits.removeAll()
    }
    
    public func value() -> Double? {
        // assuming it's not larger than the max size of a Double
        
        let string = digits.map { (digit) -> String in
            switch digit {
            case .number(let x): return String(x)
            case .decimalPoint: return "."
            }
        }.joined()
        
//        var string: String = ""
//        for digit in digits {
//            if digit == .decimalPoint && digits.first == .decimalPoint {
//                string += "0."
//            } else if digit == .decimalPoint {
//                string += "."
//            }
//            if digit == .number(let int) {
//                string += "\(int)"
//            }
//        }
        
        return Double(string)
    }
    
    
}
