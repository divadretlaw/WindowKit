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

final class WindowManager: ObservableObject {
    static var shared = WindowManager()
    
    private var allWindows: [WindowKey: UIWindow]
    var dismissSubject: PassthroughSubject<WindowKey, Never>
    
    init() {
        self.allWindows = [:]
        self.dismissSubject = PassthroughSubject()
    }
    
    private func makeIterator() -> [WindowKey: UIWindow].Iterator {
        allWindows.makeIterator()
    }
    
    func presentCover<Content>(
        key: WindowKey,
        with configuration: WindowCoverConfiguration,
        view: (UIWindow) -> Content
    ) where Content: View {
        guard allWindows[key] == nil else {
            // swiftlint:disable:next line_length
            Logger.main.error("[Presentation] Attempt to present a window with key '\(key)' while there is already a window with key '\(key)' presented on the current window scene.")
            return
        }
        
        let window = UIWindow(windowScene: key.windowScene)
        allWindows[key] = window
        
        let viewController = UIViewController(nibName: nil, bundle: nil)
        window.rootViewController = viewController
        window.windowLevel = configuration.level
        window.backgroundColor = .clear
        window.overrideUserInterfaceStyle = configuration.userInterfaceStyle
        window.tintColor = configuration.tintColor
        
        let rootView = view(window)
        
        let hostingController = WindowCoverHostingController(key: key, rootView: rootView)
        hostingController.modalTransitionStyle = configuration.modalTransitionStyle
        hostingController.modalPresentationStyle = configuration.modalPresentationStyle
        hostingController.overrideUserInterfaceStyle = configuration.userInterfaceStyle
        hostingController.isModalInPresentation = configuration.isModalInPresentation
        
        window.makeKeyAndVisible()
        window.subviews.forEach { $0.isHidden = true }
        
        DispatchQueue.main.async {
            viewController.present(hostingController, animated: true)
        }
    }
    
    func presentOverlay<Content>(
        key: WindowKey,
        with configuration: WindowOverlayConfiguration,
        view: (UIWindow) -> Content
    ) where Content: View {
        guard allWindows[key] == nil else {
            // swiftlint:disable:next line_length
            Logger.main.error("[Presentation] Attempt to present a window with key '\(key)' while there is already a window with key '\(key)' presented on the current window scene.")
            return
        }
        
        let window = PassthroughWindow(windowScene: key.windowScene)
        allWindows[key] = window
        
        let rootView = view(window)
        
        let viewController = WindowCoverHostingController(key: key, rootView: rootView)
        
        window.rootViewController = viewController
        window.windowLevel = configuration.level
        window.backgroundColor = .clear
        window.overrideUserInterfaceStyle = configuration.userInterfaceStyle
        window.tintColor = configuration.tintColor
        
        window.isHidden = false
    }
    
    func dismiss(with key: WindowKey) {
        guard let window = allWindows[key] else {
            return
        }
        
        dismissSubject.send(key)
        
        if let rootViewController = window.rootViewController {
            rootViewController.dismiss(animated: true) { [weak self] in
                window.isHidden = true
                self?.allWindows[key] = nil
            }
        } else {
            window.isHidden = true
            allWindows[key] = nil
        }
    }
}
