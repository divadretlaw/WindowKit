//
//  WindowConfiguration.swift
//  WindowKit
//
//  Created by David Walter on 14.10.23.
//

import Foundation
import SwiftUI
import UIKit

/// The configuration of the window cover
public struct WindowConfiguration {
    // MARK: - Public
    
    /// The positioning of windows relative to each other.
    public var baseLevel: UIWindow.Level = .normal
    /// The transition style to use when presenting the window cover.
    public var modalTransitionStyle: UIModalTransitionStyle = .coverVertical
    /// The presentation style for the window cover.
    public var modalPresentationStyle: UIModalPresentationStyle = .fullScreen
    /// A Boolean value indicating whether the view controller enforces a modal behavior.
    public var isModalInPresentation: Bool = true
    /// The preferred color scheme for this presentation.
    public var colorScheme: ColorScheme?
    
    // MARK: - Internal
    
    var level: UIWindow.Level = .normal
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        guard let colorScheme = colorScheme else {
            return UITraitCollection.current.userInterfaceStyle
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
}
