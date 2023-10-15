//
//  WindowCover.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI
import WindowReader
import WindowSceneReader
import OSLog

struct WindowOverlay<WindowContent>: ViewModifier where WindowContent: View {
    @Environment(\.self) private var environment
    @Environment(\.windowLevel) private var windowLevel
    
    @State var key: WindowKey?
    var windowContent: WindowContent
    var configure: ((inout WindowOverlayConfiguration) -> Void)?
    
    @ObservedObject private var windowManager = WindowManager.shared
    
    func body(content: Content) -> some View {
        if let key {
            content
                .onAppear {
                    present(with: key)
                }
                .onDisappear {
                    dismiss(with: key)
                }
        } else {
            content
                .onAppear {
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
        }
    }
    
    func present(with key: WindowKey) {
        var configuration = WindowOverlayConfiguration()
        configure?(&configuration)
        
        configuration.level = max(configuration.baseLevel, windowLevel + 1)
        
        windowManager.presentOverlay(
            key: key,
            with: configuration
        ) { window in
            windowContent
                .applyTint(configuration.color)
                .transformEnvironment(\.self) { environment in
                    environment = self.environment
                    if let colorScheme = configuration.colorScheme {
                        environment[keyPath: \.colorScheme] = colorScheme
                    }
                    
                    environment[keyPath: \.window] = window
                    environment[keyPath: \.windowLevel] = window.windowLevel
                    environment[keyPath: \.windowScene] = window.windowScene
                    environment[keyPath: \.dismissWindowCover] = WindowCoverDismissAction {
                        dismiss(with: key)
                    }
                }
        }
    }
    
    func dismiss(with key: WindowKey) {
        windowManager.dismiss(with: key)
    }
}
