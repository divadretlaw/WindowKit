//
//  EnvironmentInjectObject.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import SwiftUI
import Combine

@propertyWrapper
struct EnvironmentInjectedObject<ObjectType>: DynamicProperty where ObjectType: EnvironmentInjectable {
    @Environment(\.self) private var environmentValues
    
    @StateObject private var coordinator = Coordinator()
    
    init() {
    }
    
    @MainActor
    private final class Coordinator: ObservableObject {
        var wrappedValue: ObjectType?
        private var cancellable: AnyCancellable?
        
        func update(environmentValues: EnvironmentValues, build: @Sendable (EnvironmentValues) -> ObjectType) {
            if let wrappedValue = wrappedValue {
                wrappedValue.subject.send(environmentValues)
            } else {
                var isUpdating = true
                defer { isUpdating = false }
                
                let value = build(environmentValues)
                self.wrappedValue = value
                
                self.cancellable = value.objectWillChange
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        guard let self, !isUpdating else { return }
                        self.objectWillChange.send()
                    }
            }
        }
    }
    
    // MARK: - @propertyWrapper
    
    @MainActor var wrappedValue: ObjectType {
        coordinator.wrappedValue ?? ObjectType(environmentValues: environmentValues)
    }
    
    @MainActor var projectedValue: Wrapper {
        Wrapper(value: wrappedValue)
    }
    
    @dynamicMemberLookup struct Wrapper {
        private let value: ObjectType
        
        init(value: ObjectType) {
            self.value = value
        }
        
        subscript<Subject>(
            dynamicMember keyPath: ReferenceWritableKeyPath<ObjectType, Subject>
        ) -> Binding<Subject> {
            Binding {
                value[keyPath: keyPath]
            } set: {
                value[keyPath: keyPath] = $0
            }
        }
    }
    
    // MARK: - DynamicProperty
    
    func update() {
        coordinator.update(environmentValues: environmentValues) { environmentValues in
            ObjectType(environmentValues: environmentValues)
        }
    }
}
