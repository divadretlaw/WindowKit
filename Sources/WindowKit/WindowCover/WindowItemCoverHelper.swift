//
//  WindowItemCoverHelper.swift
//  WindowKit
//
//  Created by David Walter on 26.05.24.
//

import SwiftUI
import WindowSceneReader

struct WindowItemCoverHelper<WindowItem, WindowContent>: ViewModifier where WindowItem: Identifiable, WindowContent: View {
    var identifier: String?
    @Binding var item: WindowItem?
    let windowContent: (WindowItem) -> WindowContent
    let configure: ((inout WindowCoverConfiguration) -> Void)?
    
    @State private var windowScene: UIWindowScene?
    
    func body(content: Content) -> some View {
        if let windowScene {
            content
                .windowCover(
                    item: $item,
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
