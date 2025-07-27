//
//  CoverView.swift
//  Demo
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI

struct CoverView: View {
    @State private var isPresented = false
    @Environment(\.dismissWindowCover) private var dismiss
    @Environment(\.window) private var window
    @Environment(\.windowScene) private var windowScene
    @Environment(\.windowLevel) private var windowLevel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                    
                    Button {
                        isPresented = true
                    } label: {
                        Text("Show Cover")
                    }
                }
                
                Section {
                    HStack {
                        Text("Window Level")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(windowLevel.rawValue.description)
                            .foregroundColor(.secondary)
                    }
                    if let window {
                        VStack(alignment: .leading) {
                            Text("Window")
                                .foregroundColor(.primary)
                            Text(window.description)
                                .foregroundColor(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                    }
                    if let windowScene {
                        VStack(alignment: .leading) {
                            Text("WindowScene")
                                .foregroundColor(.primary)
                            Text(windowScene.description)
                                .foregroundColor(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                    }
                } header: {
                    Text("Debug Information")
                }
            }
            .navigationTitle("Cover")
            .navigationBarTitleDisplayMode(.inline)
            .windowCover(isPresented: $isPresented) {
                CoverView()
            } configure: { configuration in
                configuration.modalPresentationStyle = .overFullScreen
                configuration.isModalInPresentation = true
            }
        }
    }
}

#Preview {
    CoverView()
}
