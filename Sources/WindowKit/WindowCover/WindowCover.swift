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
    
    // FIXME: Workaround for initially wrong environment values
    private final class EnvironmentResolver: ObservableObject {
        @Published var colorScheme: ColorScheme?
        @Published var timeZone: TimeZone?
    }
    @StateObject private var environmentResolver = EnvironmentResolver()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.timeZone) private var timeZone
    
    @WindowIdentifier private var identifier
    
    func body(content: Content) -> some View {
        if let key {
            content
                #if os(visionOS)
                .onChange(of: identifier) {
                    windowManager.update(key: key)
                }
                .onChange(of: isPresented) { _, value in
                    if value {
                        present(with: key)
                    } else {
                        dismiss(with: key)
                    }
                }
                #else
                .onChange(of: identifier) { _ in
                    windowManager.update(key: key)
                }
                .onChange(of: isPresented) { value in
                    if value {
                        present(with: key)
                    } else {
                        dismiss(with: key)
                    }
                }
                #endif
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
                #if os(visionOS)
                .onChange(of: colorScheme) { _, colorScheme in
                    environmentResolver.colorScheme = colorScheme
                }
                .onChange(of: timeZone) { _, timeZone in
                    environmentResolver.timeZone = timeZone
                }
                #else
                .onChange(of: colorScheme) { colorScheme in
                    environmentResolver.colorScheme = colorScheme
                }
                .onChange(of: timeZone) { timeZone in
                    environmentResolver.timeZone = timeZone
                }
                #endif
        } else {
            content
                #if os(visionOS)
                .onChange(of: isPresented) { _, value in
                    guard value else { return }
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
                #else
                .onChange(of: isPresented) { value in
                    guard value else { return }
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
                #endif
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
                    // FIXME: Workaround for initially wrong environment values
                    .transformEnvironment(\.self) { environment in
                        // Some properties like 'colorScheme' that may update dynamically
                        // get copied, but then don't update for the initial presentation.
                        // Subsequent presentations after a dynamic change seem to get
                        // propagated just fine.
                        if let colorScheme = environmentResolver.colorScheme {
                            environment.colorScheme = colorScheme
                        }
                        if let timeZone = environmentResolver.timeZone {
                            environment.timeZone = timeZone
                        }
                    }
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
