//
//  WindowManager.swift
//  WindowKit
//
//  Created by David Walter on 13.10.23.
//

import Foundation
import Combine
import UIKit
import SwiftUI
import OSLog

@MainActor final class WindowManager: ObservableObject {
    static let shared = WindowManager()
    
    let dismissSubject: PassthroughSubject<WindowKey, Never>
    
    private var allWindows: [WindowKey: WindowValue]
    
    init() {
        self.allWindows = [:]
        self.dismissSubject = PassthroughSubject()
    }
    
    func presentCover<Content>(
        key: WindowKey,
        with configuration: WindowCoverConfiguration,
        view: @escaping (UIWindow) -> Content
    ) where Content: View {
        guard allWindows[key] == nil else {
            // swiftlint:disable:next line_length
            Logger.main.error("[Presentation] Attempt to present a window with key '\(key)' while there is already a window with key '\(key)' presented on the current window scene.")
            return
        }
        
        let window = UIWindow(windowScene: key.windowScene)
        allWindows[key] = WindowValue(window: window, transitioningDelegate: configuration.transitioningDelegate)

        let viewController = UIViewController(nibName: nil, bundle: nil)
        window.rootViewController = viewController
        window.windowLevel = configuration.level
        window.backgroundColor = .clear
        window.overrideUserInterfaceStyle = configuration.userInterfaceStyle
        window.tintColor = configuration.tintColor
        
        let hostingController = WindowCoverHostingController(key: key) {
            view(window)
        }
        hostingController.modalTransitionStyle = configuration.modalTransitionStyle
        hostingController.modalPresentationStyle = configuration.modalPresentationStyle
        hostingController.overrideUserInterfaceStyle = configuration.userInterfaceStyle
        hostingController.isModalInPresentation = configuration.isModalInPresentation
        hostingController.transitioningDelegate = configuration.transitioningDelegate

        window.makeKeyAndVisible()
        for subview in window.subviews {
            subview.isHidden = true
        }
        
        DispatchQueue.main.async {
            viewController.present(hostingController, animated: true)
        }
    }
    
    func presentOverlay<Content>(
        key: WindowKey,
        with configuration: WindowOverlayConfiguration,
        view: @escaping (UIWindow) -> Content
    ) where Content: View {
        guard allWindows[key] == nil else {
            // swiftlint:disable:next line_length
            Logger.main.error("[Presentation] Attempt to present a window with key '\(key)' while there is already a window with key '\(key)' presented on the current window scene.")
            return
        }
        
        let window = PassthroughWindow(windowScene: key.windowScene)
        allWindows[key] = WindowValue(window: window)

        let viewController = WindowOverlayHostingController(key: key) {
            view(window)
        }
        
        viewController.overrideUserInterfaceStyle = configuration.userInterfaceStyle
        
        window.rootViewController = viewController
        window.windowLevel = configuration.level
        window.backgroundColor = .clear
        window.overrideUserInterfaceStyle = configuration.userInterfaceStyle
        window.tintColor = configuration.tintColor
        
        window.isHidden = false
    }
    
    func isPresenting(key: WindowKey) -> Bool {
        allWindows[key] != nil
    }
    
    func update(key: WindowKey) {
        guard let value = allWindows[key] else {
            return
        }

        guard var viewController = value.findViewController(of: DynamicProperty.self) else {
            return
        }

        viewController.update()
    }
    
    func dismiss(with key: WindowKey) {
        guard let value = allWindows[key] else {
            return
        }

        dismissSubject.send(key)

        value.dismiss { [weak self] in
            self?.allWindows[key] = nil
        }
    }
    
    func dismiss(key: WindowKey, completion: @escaping () -> Void) {
        guard let value = allWindows[key] else {
            return
        }
        value.dismiss { [weak self] in
            self?.allWindows[key] = nil
            completion()
        }
    }
}
