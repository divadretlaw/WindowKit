//
//  WindowView.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import SwiftUI

/// Wrapper for the view that is displayed in a window displayed by ``WindowManager``
///
/// Propagates the environment from the calling view to the window view.
struct WindowView<Content>: View where Content: View {
    @ObservedObject private var holder: EnvironmentValuesHolder
    private var content: Content
    private var transformEnvironment: ((inout EnvironmentValues) -> Void)?
    
    @State private var environmentValues: EnvironmentValues
    
    init(
        environment holder: EnvironmentValuesHolder,
        @ViewBuilder content: () -> Content
    ) {
        self.holder = holder
        self._environmentValues = State(initialValue: holder.values)
        self.content = content()
    }
    
    var body: some View {
        content
            .onReceive(holder.subject) { values in
                environmentValues = values
            }
            .transformEnvironment(\.self) { values in
                var newValues = environmentValues
                transformEnvironment?(&newValues)
                values = newValues
            }
    }
    
    func transformEnvironment(transform: @escaping (inout EnvironmentValues) -> Void) -> Self {
        var view = self
        view.transformEnvironment = transform
        return view
    }
}
