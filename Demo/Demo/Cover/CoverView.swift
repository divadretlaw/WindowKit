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

#Preview {
    CoverView()
}
