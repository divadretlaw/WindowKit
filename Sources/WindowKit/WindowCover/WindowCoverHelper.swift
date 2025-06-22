//
//  WindowCoverHelper.swift
//  WindowKit
//
//  Created by David Walter on 14.10.23.
//

import SwiftUI
import WindowSceneReader

struct WindowCoverHelper<WindowContent>: ViewModifier where WindowContent: View {
    let identifier: String?
    @Binding var isPresented: Bool
    let windowContent: () -> WindowContent
    let configure: ((inout WindowCoverConfiguration) -> Void)?

    func body(content: Content) -> some View {
        WindowSceneReader { windowScene in
            content
                .windowCover(
                    identifier,
                    isPresented: $isPresented,
                    on: windowScene,
                    content: windowContent,
                    configure: configure
                )
        }
    }
}
