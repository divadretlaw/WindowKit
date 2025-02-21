//
//  BindingOverlay.swift
//  Demo
//
//  Created by David Walter on 21.02.25.
//

import SwiftUI

struct BindingOverlay: View {
    @Binding var isPresented: Bool
    
    @State private var toggleValue = false
    
    var body: some View {
        ZStack {
            if isPresented {
                OverlayContent()
//                    .frame(maxWidth: .infinity)
                    .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
            }
        }
        .animation(.default, value: isPresented)
    }
}

#Preview {
    BindingOverlay(isPresented: .constant(true))
}
