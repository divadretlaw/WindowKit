//
//  EnvironmentValuesHolder.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import Foundation
import Combine
import SwiftUI

final class EnvironmentValuesHolder: EnvironmentInjectable {
    var subject: CurrentValueSubject<EnvironmentValues, Never>
    
    required init(environmentValues: EnvironmentValues) {
        self.subject = CurrentValueSubject(environmentValues)
    }
    
    var values: EnvironmentValues {
        subject.value
    }
}
