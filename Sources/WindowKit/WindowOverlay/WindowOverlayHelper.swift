//
//  WindowOverlayHelper.swift
//  WindowKit
//
//  Created by David Walter on 14.10.23.
//

import SwiftUI
import WindowSceneReader

struct WindowOverlayHelper<WindowContent>: ViewModifier where WindowContent: View {
    let identifier: String?
    @ViewBuilder let windowContent: () -> WindowContent
    let configure: ((inout WindowOverlayConfiguration) -> Void)?
        
    func body(content: Content) -> some View {
        WindowSceneReader { windowScene in
            content
                .windowOverlay(
                    identifier,
                    on: windowScene,
                    content: windowContent,
                    configure: configure
                )
        }
    }
}
