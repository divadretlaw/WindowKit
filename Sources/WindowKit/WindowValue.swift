//
//  WindowValue.swift
//  WindowKit
//
//  Created by David Walter on 19.06.25.
//

import Foundation
import UIKit

struct WindowValue {
    let window: UIWindow
    let transitioningDelegate: UIViewControllerTransitioningDelegate?

    init(
        window: UIWindow,
        transitioningDelegate: UIViewControllerTransitioningDelegate? = nil
    ) {
        self.window = window
        self.transitioningDelegate = transitioningDelegate
    }

    @MainActor func findViewController<T>(of type: T.Type) -> T? {
        guard let rootViewController = window.rootViewController else { return nil }
        return rootViewController.findViewController(of: type)
    }

    @MainActor func dismiss(completion: (() -> Void)? = nil) {
        if let rootViewController = window.rootViewController {
            rootViewController.dismiss(animated: true) {
                window.isHidden = true
                completion?()
            }
        } else {
            window.isHidden = true
            completion?()
        }
    }
}
