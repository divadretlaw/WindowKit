//
//  WindowCoverDismissAction.swift
//  WindowKit
//
//  Created by David Walter on 14.10.23.
//

import SwiftUI

/// An action that dismisses the current window cover presentation.
///
/// Use the ``EnvironmentValues/dismissWindowCover`` environment value to get the instance
/// of this structure for a given `Environment`. Then call the instance
/// to perform the dismissal. You call the instance directly because
/// it defines a ``WindowCoverDismissAction/callAsFunction()``
/// method that Swift calls when you call the instance.
///
/// You can use this action to:
///  * Close a window that you create with `windowCover(_:isPresented:on:content:)`.
///
/// The specific behavior of the action depends on where you call it from.
/// For example, you can create a button that calls the ``WindowCoverDismissAction``
/// inside a view that acts as a window cover:
///
/// ```swift
/// private struct WindowCoverContents: View {
///     @Environment(\.dismissWindowCover) private var dismiss
///
///     var body: some View {
///         Button("Done") {
///             dismiss()
///         }
///     }
/// }
/// ```
///
/// When you present the `WindowCoverContents` view, someone can dismiss
/// the window cover by tapping or clicking the  window cover's button:
///
/// ```swift
/// private struct DetailView: View {
///     @State private var isWindowCoverPresented = false
///
///     var body: some View {
///         Button("Show Window Cover") {
///             isWindowCoverPresented = true
///         }
///         .windowCover(isPresented: $isWindowPresented) {
///             WindowCoverContents()
///         }
///     }
/// }
/// ```
///
/// The dismiss action has no effect on a view that isn't currently
/// presented in a window cover.
public struct WindowCoverDismissAction {
    var action: (() -> Void)?
    
    /// Dismisses the window cover if it is currently presented.
    ///
    /// Don't call this method directly. SwiftUI calls it for you when you
    /// call the ``WindowCoverDismissAction`` structure that you get from the
    /// `Environment`:
    ///
    /// ```swift
    /// private struct WindowCoverContents: View {
    ///     @Environment(\.dismissWindowCover) private var dismiss
    ///
    ///     var body: some View {
    ///         Button("Done") {
    ///             dismiss() // Implicitly calls dismiss.callAsFunction()
    ///         }
    ///     }
    /// }
    /// ```
    public func callAsFunction() {
        action?()
    }
}

private struct WindowCoverDismissActionKey: EnvironmentKey {
    static var defaultValue: WindowCoverDismissAction {
        WindowCoverDismissAction()
    }
}

public extension EnvironmentValues {
    /// An action that dismisses the current window cover presentation.
    ///
    /// Use the ``EnvironmentValues/dismissWindowCover`` environment value to get the instance
    /// of this structure for a given `Environment`. Then call the instance
    /// to perform the dismissal. You call the instance directly because
    /// it defines a ``WindowCoverDismissAction/callAsFunction()``
    /// method that Swift calls when you call the instance.
    ///
    /// You can use this action to:
    ///  * Close a window that you create with `windowCover(_:isPresented:on:content:)`.
    ///
    /// The specific behavior of the action depends on where you call it from.
    /// For example, you can create a button that calls the ``WindowCoverDismissAction``
    /// inside a view that acts as a window cover:
    ///
    /// ```swift
    /// private struct WindowCoverContents: View {
    ///     @Environment(\.dismissWindowCover) private var dismiss
    ///
    ///     var body: some View {
    ///         Button("Done") {
    ///             dismiss()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// When you present the `WindowCoverContents` view, someone can dismiss
    /// the window cover by tapping or clicking the window cover's button:
    ///
    /// ```swift
    /// private struct DetailView: View {
    ///     @State private var isWindowCoverPresented = false
    ///
    ///     var body: some View {
    ///         Button("Show Window Cover") {
    ///             isWindowCoverPresented = true
    ///         }
    ///         .windowCover(isPresented: $isWindowPresented) {
    ///             WindowCoverContents()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// The dismiss action has no effect on a view that isn't currently
    /// presented in a window cover.
    var dismissWindowCover: WindowCoverDismissAction {
        get { self[WindowCoverDismissActionKey.self] }
        set { self[WindowCoverDismissActionKey.self] = newValue }
    }
}
