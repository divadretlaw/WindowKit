//
//  UIViewController+Extensions.swift
//  WindowKit
//
//  Created by David Walter on 01.09.24.
//

import UIKit

extension UIViewController {
    func findViewController<T>(of type: T.Type) -> T? {
        if let result = self as? T {
            return result
        } else {
            return presentedViewController?.findViewController(of: type)
        }
    }
}
