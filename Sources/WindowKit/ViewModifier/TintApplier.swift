//
//  TintApplier.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI

extension View {
    func applyTint(_ color: Color?) -> some View {
        modifier(TintApplier(color: color))
    }
}

private struct TintApplier: ViewModifier {
    var color: Color?
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.tint(color)
        } else if #available(iOS 15.0, *) {
            content.tint(color)
        } else {
            content.foregroundColor(color)
        }
    }
}
