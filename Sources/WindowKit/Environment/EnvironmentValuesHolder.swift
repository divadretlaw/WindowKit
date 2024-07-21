//
//  EnvironmentValuesHolder.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import Foundation
import Combine
import SwiftUI

final class EnvironmentValuesHolder: ObservableObject {
    let subject: CurrentValueSubject<EnvironmentValues, Never>
    
    init() {
        self.subject = CurrentValueSubject(EnvironmentValues())
    }
    
    required init(environmentValues: EnvironmentValues) {
        self.subject = CurrentValueSubject(environmentValues)
    }
    
    var values: EnvironmentValues {
        subject.value
    }
}
