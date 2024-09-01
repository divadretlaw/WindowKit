//
//  WindowKey.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import Foundation
import UIKit

struct WindowKey: Identifiable, Hashable, Equatable, Sendable, CustomStringConvertible {
    let identifier: String
    let windowScene: UIWindowScene
    
    init?(identifier: String?, windowScene: UIWindowScene?) {
        guard let windowScene = windowScene else { return nil }
        
        self.identifier = identifier ?? UUID().uuidString
        self.windowScene = windowScene
    }
    
    init(identifier: String?, windowScene: UIWindowScene) {
        self.identifier = identifier ?? UUID().uuidString
        self.windowScene = windowScene
    }
    
    // MARK: - Identifiable
    
    var id: String {
        identifier
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(windowScene)
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier && lhs.windowScene == rhs.windowScene
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        identifier.description
    }
}
