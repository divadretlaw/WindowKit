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
