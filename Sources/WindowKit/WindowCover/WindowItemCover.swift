//
//  WindowItemCover.swift
//  WindowKit
//
//  Created by David Walter on 26.05.24.
//

import SwiftUI
import OSLog

struct WindowItemCover<WindowItem, WindowContent>: ViewModifier where WindowItem: Identifiable, WindowContent: View {
    @Environment(\.windowLevel) private var windowLevel
    
    @DynamicWindowKey var key: WindowKey?
    @Binding var item: WindowItem?
    let windowContent: (WindowItem) -> WindowContent
    let configure: ((inout WindowCoverConfiguration) -> Void)?

    @ObservedObject private var windowManager = WindowManager.shared
    @StateObject private var environmentHolder = EnvironmentValuesHolder()
    
    func body(content: Content) -> some View {
        if let key {
            content
                #if os(visionOS)
                .onChange(of: item?.id) { _, value in
                    change(with: key, id: value)
                }
                #else
                .onChange(of: item?.id) { newValue in
                    change(with: key, id: newValue)
                }
                #endif
                .onAppear {
                    guard let item else { return }
                    present(with: key, item: item)
                }
                .onDisappear {
                    dismiss(with: key)
                }
                .transformEnvironment(\.self) { values in
                    environmentHolder.subject.send(values)
                }
                .onReceive(windowManager.dismissSubject) { value in
                    guard value == key else { return }
                    item = nil
                }
        } else {
            content
                #if os(visionOS)
                .onChange(of: item?.id) { _, value in
                    guard value != nil else { return }
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
                #else
                .onChange(of: item?.id) { value in
                    guard value != nil else { return }
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
                #endif
                .onAppear {
                    guard item != nil else { return }
                    Logger.main.error("[Presentation] Attempt to present a window cover without a window scene.")
                }
        }
    }
    
    func present(with key: WindowKey, item: WindowItem) {
        var configuration = WindowCoverConfiguration()
        configure?(&configuration)
        
        configuration.level = max(configuration.baseLevel, windowLevel + 1)
        
        windowManager.presentCover(
            key: key,
            with: configuration
        ) { window in
            WindowView(environment: environmentHolder) {
                windowContent(item)
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
    
    func change(with key: WindowKey, id: WindowItem.ID?) {
        guard let item else {
            dismiss(with: key)
            return
        }
        
        if windowManager.isPresenting(key: key) {
            replace(with: key, item: item)
        } else if id != nil {
            present(with: key, item: item)
        } else {
            dismiss(with: key)
        }
    }
    
    func update(with key: WindowKey) {
        windowManager.update(key: key)
    }
    
    func replace(with key: WindowKey, item: WindowItem) {
        let oldKey = key
        let newKey = WindowKey(identifier: UUID().uuidString, windowScene: key.windowScene)
        self.key = newKey
        
        windowManager.dismiss(key: oldKey) {
            present(with: newKey, item: item)
        }
    }
    
    func dismiss(with key: WindowKey) {
        windowManager.dismiss(with: key)
    }
}
