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
    #if swift(>=5.10)
    nonisolated(unsafe) static let main = Logger(subsystem: "at.davidwalter.WindowKit", category: "WindowKit")
    #else
    static let main = Logger(subsystem: "at.davidwalter.WindowKit", category: "WindowKit")
    #endif
}
