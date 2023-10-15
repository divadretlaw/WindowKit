//
//  ContentView.swift
//  Demo
//
//  Created by David Walter on 14.10.23.
//

import SwiftUI
import WindowKit

struct ContentView: View {
    @Environment(\.windowScene) private var windowScene
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            List {
                Button {
                    isPresented = true
                } label: {
                    Text("Show Overlay")
                }
                
                Text(isPresented.description)
            }
            .navigationTitle("Demo")
            .windowCover(isPresented: $isPresented) {
                Overlay()
            } configure: { configuration in
                configuration.colorScheme = .dark
                configuration.modalTransitionStyle = .flipHorizontal
                configuration.modalPresentationStyle = .formSheet
                configuration.isModalInPresentation = false
            }
        }
    }
}

struct Overlay: View {
    @State private var isPresented = false
    @Environment(\.dismissWindowCover) private var dismiss
    @Environment(\.windowLevel) private var windowLevel
    
    var body: some View {
        NavigationView {
            List {
                Button {
                     dismiss()
                } label: {
                    Text("Dismiss")
                }
                
                Button {
                    isPresented = true
                } label: {
                    Text("Show Overlay")
                }
                
                Text(windowLevel.rawValue.description)
            }
            .navigationTitle("Overlay")
            .windowCover("asdf", isPresented: $isPresented) {
                Overlay()
            } configure: { configuration in
                configuration.modalPresentationStyle = .overFullScreen
            }
        }
    }
}

#Preview {
    ContentView()
}
