//
//  WindowState.swift
//  WindowKit
//
//  Created by David Walter on 11.03.24.
//

import SwiftUI

@MainActor
@propertyWrapper
struct WindowState: DynamicProperty {
    let storage: State<WindowKey?>

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
    
    private func process(_ value: WindowKey?) {
        DispatchQueue.main.async {
            if let value {
                WindowManager.shared.update(key: value)
            }
            self.storage.wrappedValue = value
        }
    }
    
    // MARK: - DynamicProperty
    
    public mutating nonisolated func update() {
        MainActor.runSync {
            let value = storage.wrappedValue
            DispatchQueue.main.async {
                if let value {
                    WindowManager.shared.update(key: value)
                }
            }
        }
    }
}
