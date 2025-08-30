//
//  WindowCoverConfiguration.swift
//  WindowKit
//
//  Created by David Walter on 14.10.23.
//

import Foundation
import SwiftUI
import UIKit

/// The configuration of the window cover
public struct WindowCoverConfiguration {
    // MARK: - Public
    
    /// The tint color for the window cover.
    public var tintColor: UIColor = .defaultColor
    /// The positioning of windows relative to each other.
    public var baseLevel: UIWindow.Level = .normal
    /// The transition style to use when presenting the window cover.
    public var modalTransitionStyle: UIModalTransitionStyle = .coverVertical
    /// The presentation style for the window cover.
    public var modalPresentationStyle: UIModalPresentationStyle = .fullScreen
    /// A Boolean value indicating whether the view controller enforces a modal behavior.
    public var isModalInPresentation: Bool = true
    /// The delegate object that provides transition animator, interactive controller, and custom presentation controller objects.
    public var transitioningDelegate: UIViewControllerTransitioningDelegate? = nil
    /// The preferred color scheme for this presentation.
    public var colorScheme: ColorScheme?
    private var _sheetConfiguration: Any?
    /// The sheet configuration of the window cover
    @available(iOS 15.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    var sheetConfiguration: WindowCoverSheetConfiguration? {
        get {
            _sheetConfiguration as? WindowCoverSheetConfiguration
        }
        set {
            _sheetConfiguration = newValue
        }
    }

    @available(iOS 15.0, *)
    @available(tvOS, unavailable)
    @available(visionOS, unavailable)
    public mutating func sheetPresentation(configure: (inout WindowCoverSheetConfiguration) -> Void) {
        var configuration = sheetConfiguration ?? WindowCoverSheetConfiguration()
        configure(&configuration)
        sheetConfiguration = configuration
    }

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
