//
//  WindowView.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import SwiftUI
import WindowReader
import WindowSceneReader

struct WindowView<Content>: View where Content: View {
    var content: Content
    var transformEnvironment: ((inout EnvironmentValues) -> Void)?
    
    @State private var environmentValues: EnvironmentValues
    @ObservedObject private var environmentHolder: EnvironmentHolder
    
    init(
        environment: EnvironmentHolder,
        @ViewBuilder content: () -> Content
    ) {
        self.environmentHolder = environment
        self._environmentValues = State(initialValue: environment.values)
        self.content = content()
    }
    
    var body: some View {
        content
            .onReceive(environmentHolder.subject) { values in
                environmentValues = values
            }
            .transformEnvironment(\.self) { environment in
                var transformedValues = environmentValues
                transformEnvironment?(&transformedValues)
                environment = transformedValues
            }
    }
    
    func transformEnvironment(transform: @escaping (inout EnvironmentValues) -> Void) -> Self {
        var view = self
        view.transformEnvironment = transform
        return view
    }
}
