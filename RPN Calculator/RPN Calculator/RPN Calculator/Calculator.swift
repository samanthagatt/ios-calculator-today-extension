//
//  Calculator.swift
//  RPN Calculator
//
//  Created by Samantha Gatt on 9/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

public struct Calculator {
    public init() {}
    
    public enum Operator {
        case add, subtract, multiply, divide
    }
    
    private var stack: Stack<Double> = [0.0, 0.0]
    
    public mutating func push(number: Double) {
        stack.push(number)
    }
    
    public mutating func push(operator: Operator) {
        let operand2 = stack.pop() ?? 0.0
        let operand1 = stack.pop() ?? 0.0
        
        let result: Double
        // back ticks tell swift that the variable operator is not the keyword operator
        switch `operator` {
        case .add:
            result = operand1 + operand2
        case .subtract:
            result = operand1 - operand2
        case .multiply:
            result = operand1 * operand2
        case .divide:
            result = operand1 / operand2
        }
        stack.push(result)
    }
    
    public mutating func clear() {
        stack = [0.0, 0.0]
    }
    
    public var topValue: Double? {
        return stack.peek()
    }
}
