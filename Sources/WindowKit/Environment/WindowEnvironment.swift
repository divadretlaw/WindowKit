//
//  WindowEnvironment.swift
//  WindowKey
//
//  Created by David Walter on 28.10.23.
//

import SwiftUI
import Combine

struct WindowEnvironment {
    var key: WindowKey
    var values: EnvironmentValues
}

final class EnvironmentHolder: ObservableObject {
    var subject: CurrentValueSubject<EnvironmentValues, Never>
    
    init() {
        self.subject = CurrentValueSubject(EnvironmentValues())
    }
    
    var values: EnvironmentValues {
        subject.value
    }
}
