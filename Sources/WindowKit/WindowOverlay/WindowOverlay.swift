//
//  WindowCover.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI
import OSLog

struct WindowOverlay<WindowContent>: ViewModifier where WindowContent: View {
    @Environment(\.windowLevel) private var windowLevel
    
    @State var key: WindowKey?
    @ViewBuilder var windowContent: () -> WindowContent
    var configure: ((inout WindowOverlayConfiguration) -> Void)?
    
    @ObservedObject private var windowManager = WindowManager.shared
    @EnvironmentInjectedObject private var environmentHolder: EnvironmentValuesHolder
    
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
            WindowView(environment: environmentHolder) {
                windowContent()
                    .applyTint(configuration.color)
            }
            .transformEnvironment { values in
                if let colorScheme = configuration.colorScheme {
                    values[keyPath: \.colorScheme] = colorScheme
                }
                
                values[keyPath: \.window] = window
                values[keyPath: \.windowLevel] = window.windowLevel
                values[keyPath: \.windowScene] = window.windowScene
                values[keyPath: \.dismissWindowCover] = WindowCoverDismissAction {
                    dismiss(with: key)
                }
            }
        }
    }
    
    func dismiss(with key: WindowKey) {
        windowManager.dismiss(with: key)
    }
}
