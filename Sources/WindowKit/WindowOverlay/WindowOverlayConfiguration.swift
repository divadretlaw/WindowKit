//
//  WindowOverlayConfiguration.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import Foundation
import SwiftUI
import UIKit

/// The configuration of the window cover
public struct WindowOverlayConfiguration {
    // MARK: - Public
    
    /// The tint color for the window cover.
    public var tintColor: UIColor = .defaultColor
    /// The positioning of windows relative to each other.
    public var baseLevel: UIWindow.Level = .normal
    /// The preferred color scheme for this presentation.
    public var colorScheme: ColorScheme?
    
    // MARK: - Internal
    
    var level: UIWindow.Level = .normal
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        guard let colorScheme else {
            return .unspecified
        }
        
        switch colorScheme {
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .unspecified
        }
    }
    
    var color: Color {
        if #available(iOS 15.0, tvOS 15.0, *) {
            Color(uiColor: tintColor)
        } else {
            Color(tintColor)
        }
    }
}

private extension UIColor {
    static var defaultColor: UIColor {
        if #available(iOS 15.0, tvOS 15.0, *) {
            return .tintColor
        } else {
            return UIColor(named: "AccentColor", in: .main, compatibleWith: nil) ?? .systemBlue
        }
    }
}
