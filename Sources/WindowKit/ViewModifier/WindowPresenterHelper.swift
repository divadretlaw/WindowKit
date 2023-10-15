//
//  WindowKitHelper.swift
//  WindowKit
//
//  Created by David Walter on 14.10.23.
//

import SwiftUI
import WindowSceneReader

struct WindowKitHelper<WindowContent>: ViewModifier where WindowContent: View {
    var identifier: String?
    @Binding var isPresented: Bool
    var windowContent: () -> WindowContent
    var configure: ((inout WindowConfiguration) -> Void)?
    
    @State private var windowScene: UIWindowScene?
    
    func body(content: Content) -> some View {
        if let windowScene {
            content
                .windowCover(
                    identifier,
                    isPresented: $isPresented,
                    on: windowScene,
                    content: windowContent,
                    configure: configure
                )
        } else {
            content
                .captureWindowScene { windowScene in
                    self.windowScene = windowScene
                }
        }
    }
}
