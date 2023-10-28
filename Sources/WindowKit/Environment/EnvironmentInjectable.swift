//
//  EnvironmentInjectable.swift
//  WindowKit
//
//  Created by David Walter on 28.10.23.
//

import Foundation
import Combine
import SwiftUI

protocol EnvironmentInjectable: ObservableObject {
    var subject: CurrentValueSubject<EnvironmentValues, Never> { get }
    
    init(environmentValues: EnvironmentValues)
    
    var values: EnvironmentValues { get }
}
