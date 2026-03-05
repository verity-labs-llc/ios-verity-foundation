//
//  Binding+Arithmetic.swift
//  VerityLabsFoundation
//
//  Created by Codex on 3/5/26.
//

import SwiftUI

public func +=<Value: AdditiveArithmetic>(lhs: inout Binding<Value>, rhs: Value) {
    lhs.wrappedValue = lhs.wrappedValue + rhs
}

public func -=<Value: AdditiveArithmetic>(lhs: inout Binding<Value>, rhs: Value) {
    lhs.wrappedValue = lhs.wrappedValue - rhs
}
