//
//  EnvironmentExtensions.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import SwiftUI

extension EnvironmentValues: Equatable {
    public static func == (lhs: EnvironmentValues, rhs: EnvironmentValues) -> Bool {
        lhs.description == rhs.description
    }
}
