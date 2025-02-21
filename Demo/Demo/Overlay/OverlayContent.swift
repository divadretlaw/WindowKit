//
//  OverlayContent.swift
//  Demo
//
//  Created by David Walter on 22.02.25.
//

import SwiftUI

struct OverlayContent: View {
    @Environment(\.windowLevel) private var windowLevel
    @State private var toggleValue = false
    
    var body: some View {
        VStack(spacing: 10) {
            VStack {
                Text("Hello Overlay")
                    .foregroundColor(.primary)
                Text("Window Level: \(windowLevel.rawValue.description)")
                    .foregroundColor(.secondary)
                
                Button {
                    toggleValue.toggle()
                } label: {
                    Text("Change Value")
                }
                
                if toggleValue {
                    Text("Value A")
                        .foregroundColor(.blue)
                    Text("Additional text")
                } else {
                    Text("Value B")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground).opacity(0.8))
        .border(Color.accentColor)
        .animation(.default, value: toggleValue)
    }
}

#Preview {
    OverlayContent()
}
