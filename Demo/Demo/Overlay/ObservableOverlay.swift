//
//  ObservableOverlay.swift
//  Demo
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI

struct ObservableOverlay: View {
    @ObservedObject var viewModel: OverlayViewModel
    
    @State private var toggleValue = false
    
    var body: some View {
        ZStack {
            if viewModel.isPresented {
                OverlayContent()
                    .frame(maxWidth: .infinity)
                    .transition(.slide)
            }
        }
        .animation(.default, value: viewModel.isPresented)
    }
}

#Preview {
    ObservableOverlay(viewModel: OverlayViewModel())
}
