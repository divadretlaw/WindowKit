//
//  API.swift
//  WindowKit
//
//  Created by David Walter on 13.10.23.
//

import SwiftUI
@_exported import WindowReader
@_exported import WindowSceneReader

// MARK: - Public

public extension View {
    /// Presents a modal view within its own `UIWIndow` when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - identifier: Optional identifier of the window that is presenting the window cover.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the window cover that you create in the modifier's.
    ///   - windowScene: The window scene to present the window cover on.
    ///   - content: A closure that returns the content of the window cover.
    ///   - configure: A closure to configure the window cover.
    @warn_unqualified_access func windowCover<Content>(
        _ identifier: String? = nil,
        isPresented: Binding<Bool>,
        on windowScene: UIWindowScene?,
        @ViewBuilder content: @escaping () -> Content,
        configure: ((inout WindowCoverConfiguration) -> Void)? = nil
    ) -> some View where Content: View {
        modifier(
            WindowCover(
                key: WindowKey(
                    identifier: identifier,
                    windowScene: windowScene
                ),
                isPresented: isPresented,
                windowContent: content,
                configure: configure
            )
        )
    }
    
    /// Presents an overlay within its own `UIWIndow` when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - identifier: Optional identifier of the window that is presenting the window cover.
    ///   - windowScene: The window scene to present the window cover on.
    ///   - content: A closure that returns the content of the window cover.
    ///   - configure: A closure to configure the window cover.
    @warn_unqualified_access func windowOverlay<Content>(
        _ identifier: String? = nil,
        on windowScene: UIWindowScene?,
        @ViewBuilder content: @escaping () -> Content,
        configure: ((inout WindowOverlayConfiguration) -> Void)? = nil
    ) -> some View where Content: View {
        modifier(
            WindowOverlay(
                key: WindowKey(
                    identifier: identifier,
                    windowScene: windowScene
                ),
                windowContent: content,
                configure: configure
            )
        )
    }
}

public extension View {
    /// Presents a modal view within its own `UIWIndow` when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - identifier: Optional identifier of the window that is presenting the window cover.
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the window cover that you create in the modifier's.
    ///   - content: A closure that returns the content of the window cover.
    ///   - configure: A closure to configure the window cover.
    @warn_unqualified_access func windowCover<Content>(
        _ identifier: String? = nil,
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content,
        configure: ((inout WindowCoverConfiguration) -> Void)? = nil
    ) -> some View where Content: View {
        modifier(
            WindowCoverHelper(
                identifier: identifier,
                isPresented: isPresented,
                windowContent: content,
                configure: configure
            )
        )
    }
    
    /// Presents an overlay within its own `UIWIndow` when binding to a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - identifier: Optional identifier of the window that is presenting the window cover.
    ///   - windowScene: The window scene to present the window cover on.
    ///   - content: A closure that returns the content of the window cover.
    ///   - configure: A closure to configure the window cover.
    @warn_unqualified_access func windowOverlay<Content>(
        _ identifier: String? = nil,
        @ViewBuilder content: @escaping () -> Content,
        configure: ((inout WindowOverlayConfiguration) -> Void)? = nil
    ) -> some View where Content: View {
        modifier(
            WindowOverlayHelper(
                identifier: identifier,
                windowContent: content,
                configure: configure
            )
        )
    }
}
