//
//  DynamicWindowKey.swift
//  WindowKit
//
//  Created by David Walter on 11.03.24.
//

import SwiftUI

@MainActor
@propertyWrapper
struct DynamicWindowKey: DynamicProperty, Sendable {
    private let storage: State<WindowKey?>

    init(wrappedValue value: WindowKey?) {
        self.storage = State<WindowKey?>(initialValue: value)
    }
    
    var wrappedValue: WindowKey? {
        get {
            storage.wrappedValue
        }
        nonmutating set {
            storage.wrappedValue = newValue
        }
    }
    
    var projectedValue: Binding<WindowKey?> {
        storage.projectedValue
    }
    
    // MARK: - DynamicProperty
    
    mutating nonisolated func update() {
        MainActor.runSync {
            let value = storage.wrappedValue
            if let value {
                WindowManager.shared.update(key: value)
            }
        }
    }
}