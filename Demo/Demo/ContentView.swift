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
    @State private var isCustomPresented = false
    @State private var showOverlay = false
    
    @StateObject private var overlayViewModel = OverlayViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        isPresented = true
                    } label: {
                        Text("Show Cover")
                    }
                    Text(isPresented.description)
                } header: {
                    Text("`.windowCover`")
                        .textCase(nil)
                }

                Section {
                    Button {
                        isCustomPresented = true
                    } label: {
                        Text("Show Cover")
                    }
                    Text(isCustomPresented.description)
                } header: {
                    Text("`.windowCover` w/ custom transition")
                        .textCase(nil)
                }

                Section {
                    Button {
                        overlayViewModel.isPresented.toggle()
                    } label: {
                        Text("Toggle Overlay")
                    }
                    Text(overlayViewModel.isPresented.description)
                } header: {
                    Text("`.windowOverlay` w/ ObservableObject")
                        .textCase(nil)
                }
                
                Section {
                    Button {
                        showOverlay.toggle()
                    } label: {
                        Text("Toggle Overlay")
                    }
                    Text(showOverlay.description)
                } header: {
                    Text("`.windowOverlay` w/ State")
                        .textCase(nil)
                }
            }
            .navigationTitle("Demo")
            .windowCover(isPresented: $isPresented, on: windowScene) {
                CoverView()
            } configure: { configuration in
                configuration.colorScheme = .dark
                configuration.modalTransitionStyle = .flipHorizontal
                configuration.modalPresentationStyle = .formSheet
                configuration.sheetPresentation { configuration in
                    configuration.detents = [.medium()]
                }
            }
            .windowCover(isPresented: $isCustomPresented, on: windowScene) {
                CoverView()
            } configure: { configuration in
                configuration.modalPresentationStyle = .custom
                configuration.transitioningDelegate = CustomTransition()
            }
            .windowOverlay(on: windowScene) {
                ObservableOverlay(viewModel: overlayViewModel)
            } configure: { configuration in
                configuration.baseLevel = UIWindow.Level(2)
            }
            .windowOverlay(on: windowScene) {
                BindingOverlay(isPresented: $showOverlay)
            } configure: { configuration in
                configuration.baseLevel = UIWindow.Level(10_000)
                configuration.colorScheme = .dark
            }
        }
    }
}

#Preview {
    ContentView()
}
