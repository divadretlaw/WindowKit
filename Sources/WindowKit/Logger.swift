//
//  Logger.swift
//  WindowKit
//
//  Created by David Walter on 14.10.23.
//

import Foundation
import OSLog
import UIKit

extension Logger {
    static var main = Logger(subsystem: "at.davidwalter.WindowKit", category: "WindowKit")
}

extension UIUserInterfaceStyle: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unspecified:
            return "unspecified"
        case .dark:
            return "dark"
        case .light:
            return "light"
        @unknown default:
            return "unknown default"
        }
    }
}
