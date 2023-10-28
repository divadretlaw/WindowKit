//
//  WindowCover.swift
//  WindowKit
//
//  Created by David Walter on 13.10.23.
//

import SwiftUI
import OSLog

struct WindowCover<WindowContent>: ViewModifier where WindowContent: View {
    @Environment(\.windowLevel) private var windowLevel
    
    @State var key: WindowKey?
    @Binding var isPresented: Bool
    var windowContent: () -> WindowContent
    var configure: ((inout WindowCoverConfiguration) -> Void)?
    
    @ObservedObject private var windowManager = WindowManager.shared
    @EnvironmentInjectedObject private var environmentHolder: EnvironmentValuesHolder
    
    func body(content: Content) -> some View {
        if let key {
            content
                .onChange(of: isPresented) { value in
                    if value {
                        present(with: key)
                    } else {
                        dismiss(with: key)
                    }
                }
                .onAppear {
                    guard isPresented else { return }
                    present(with: key)
                }
                .onDisappear {
                    dismiss(with: key)
                }
                .onReceive(windowManager.dismissSubject) { value in
                    guard value == key else { return }
                    isPresented = false
                }
        } else {
            content
                .onChange(of: isPresented) { value in
                    guard value else { return }
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
                .onAppear {
                    guard isPresented else { return }
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
        }
    }
    
    func present(with key: WindowKey) {
        var configuration = WindowCoverConfiguration()
        configure?(&configuration)
        
        configuration.level = max(configuration.baseLevel, windowLevel + 1)
        
        windowManager.presentCover(
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
