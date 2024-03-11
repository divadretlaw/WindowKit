//
//  WindowIdentifier.swift
//  WindowKit
//
//  Created by David Walter on 11.03.24.
//

import SwiftUI

@propertyWrapper struct WindowIdentifier: DynamicProperty, Hashable {
    var wrappedValue: UUID
    
    init() {
        self.wrappedValue = UUID()
    }
    
    mutating func update() {
        wrappedValue = UUID()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
