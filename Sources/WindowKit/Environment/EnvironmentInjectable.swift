//
//  EnvironmentInjectable.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import Foundation
import Combine
import SwiftUI

/// Base protocol for ``EnvironmentInjectedObject``
protocol EnvironmentInjectable: ObservableObject {
    /// The subject that holds the current `EnvironmentValues`
    var subject: CurrentValueSubject<EnvironmentValues, Never> { get }
    
    /// Create a new observable object from the given `EnvironmentValues`
    init(environmentValues: EnvironmentValues)
    
    /// Access the current `EnvironmentValues`
    var values: EnvironmentValues { get }
}
