//
//  WindowCoverSheetConfiguration.swift
//  WindowKit
//
//  Created by David Walter on 27.07.25.
//

import Foundation
import SwiftUI
import UIKit

#if os(iOS)
/// The sheet configuration of the window cover
@available(iOS 15.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct WindowCoverSheetConfiguration {
    public var detents: [UISheetPresentationController.Detent]
    public var selectedDetentsIdentifier: UISheetPresentationController.Detent.Identifier?
    public var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    public var prefersScrollingExpandsWhenScrolledToEdge: Bool
    public var prefersGrabberVisible: Bool
    public var prefersPageSizing: Bool
    public var prefersEdgeAttachedInCompactHeight: Bool
    public var widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    public var preferredCornerRadius: CGFloat?

    public init() {
        self.detents = [.large()]
        self.selectedDetentsIdentifier = nil
        self.largestUndimmedDetentIdentifier = nil
        self.prefersScrollingExpandsWhenScrolledToEdge = true
        self.prefersGrabberVisible = false
        self.prefersPageSizing = true
        self.prefersEdgeAttachedInCompactHeight = false
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = false
        self.preferredCornerRadius = nil
    }
}

@available(iOS 15.0, *)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
extension UISheetPresentationController {
    func apply(_ configuration: WindowCoverSheetConfiguration?) {
        guard let configuration else { return }

        detents = configuration.detents
        selectedDetentIdentifier = configuration.selectedDetentsIdentifier
        largestUndimmedDetentIdentifier = configuration.largestUndimmedDetentIdentifier
        prefersScrollingExpandsWhenScrolledToEdge = configuration.prefersScrollingExpandsWhenScrolledToEdge
        prefersGrabberVisible = configuration.prefersGrabberVisible
        if #available(iOS 17.0, *) {
            prefersPageSizing = configuration.prefersPageSizing
        }
        prefersEdgeAttachedInCompactHeight = configuration.prefersEdgeAttachedInCompactHeight
        widthFollowsPreferredContentSizeWhenEdgeAttached = configuration.widthFollowsPreferredContentSizeWhenEdgeAttached
        preferredCornerRadius = configuration.preferredCornerRadius
    }
}
#else
/// The sheet configuration of the window cover
public struct WindowCoverSheetConfiguration {
}
#endif
