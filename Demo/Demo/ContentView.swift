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
    
    @StateObject private var overlayViewModel = OverlayViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        isPresented = true
                    } label: {
                        Text("Show Overlay")
                    }
                    Text(isPresented.description)
                }
                
                Section {
                    Button {
                        overlayViewModel.isPresented.toggle()
                    } label: {
                        Text("Toggle Root Overlay")
                    }
                    Text(overlayViewModel.isPresented.description)
                }
                
            }
            .navigationTitle("Demo")
            .windowCover(isPresented: $isPresented) {
                CoverView()
            } configure: { configuration in
                // configuration.colorScheme = .dark
                configuration.modalTransitionStyle = .flipHorizontal
                configuration.modalPresentationStyle = .formSheet
                configuration.isModalInPresentation = false
            }
            .windowOverlay(on: windowScene) {
                Overlay(viewModel: overlayViewModel)
            } configure: { configuration in
                configuration.baseLevel = UIWindow.Level(10_000)
            }
        }
    }
}

#Preview {
    ContentView()
}
