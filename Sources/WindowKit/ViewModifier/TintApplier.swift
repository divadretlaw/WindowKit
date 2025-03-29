//
//  TintApplier.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI

extension View {
    /// Sets the tint within this view.
    ///
    /// - Parameter color: The tint `Color` to apply.
    ///
    /// > Info: Workaround for iOS 14 since `tint` is only available for iOS 15 or newer
    func applyTint(_ color: Color?) -> some View {
        modifier(TintApplier(color: color))
    }
}

private struct TintApplier: ViewModifier {
    let color: Color?
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, tvOS 15.0, visionOS 1.0, *) {
            content.tint(color)
        } else {
            content.foregroundColor(color)
        }
    }
}
