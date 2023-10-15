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
    @State private var isRootPresented = true
    
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
                        isRootPresented.toggle()
                    } label: {
                        Text("Toggle Root Overlay")
                    }
                    Text(isRootPresented.description)
                }
                
            }
            .navigationTitle("Demo")
            .windowCover(isPresented: $isPresented) {
                CoverView()
            } configure: { configuration in
                configuration.colorScheme = .dark
                configuration.modalTransitionStyle = .flipHorizontal
                configuration.modalPresentationStyle = .formSheet
                configuration.isModalInPresentation = false
            }
            .windowOverlay(on: windowScene) {
                if isRootPresented {
                    Overlay()
                }
            } configure: { configuration in
                configuration.baseLevel = UIWindow.Level(10_000)
            }
        }
    }
}

struct CoverView: View {
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
                CoverView()
            } configure: { configuration in
                configuration.modalPresentationStyle = .overFullScreen
            }
        }
    }
}

struct Overlay: View {
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Button {
                isPresented.toggle()
            } label: {
                Text("Change")
            }
            
            if isPresented {
                Text("Test A")
                    .foregroundColor(.blue)
            } else {
                Text("Test B")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.green)
        .cornerRadius(30)
        .transition(.slide)
    }
}

#Preview {
    ContentView()
}
