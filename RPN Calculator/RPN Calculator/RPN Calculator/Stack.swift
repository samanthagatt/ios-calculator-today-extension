//
//  Stack.swift
//  RPN Calculator
//
//  Created by Samantha Gatt on 9/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct Stack<T>: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = T
    
    init(arrayLiteral elements: ArrayLiteralElement...) {
        items = elements
    }
    
    init(_ initialItems: [T] = []) {
        items = initialItems
    }
    
    private(set) var items: [T]
    
    mutating func push(_ value: T) {
        items.append(value)
    }
    
    mutating func pop() -> T? {
        return items.popLast()
    }

    func peek() -> T? {
        return items.last
    }
}
