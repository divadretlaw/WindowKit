//
//  Overlay.swift
//  Demo
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI

struct Overlay: View {
    @ObservedObject var viewModel: OverlayViewModel
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            if viewModel.isPresented {
                VStack(spacing: 10) {
                    VStack {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("Change Value")
                        }
                        
                        if isPresented {
                            Text("Value A")
                                .foregroundColor(.blue)
                        } else {
                            Text("Value B")
                                .foregroundColor(.red)
                        }
                    }
                    
                    Text("Hello World")
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.systemGroupedBackground).opacity(0.8))
                .border(Color.accentColor)
                .frame(maxWidth: .infinity)
                .transition(.slide)
            }
        }
        .animation(.default, value: viewModel.isPresented)
    }
}

#Preview {
    Overlay(viewModel: OverlayViewModel())
}
