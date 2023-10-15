//
//  PassthroughWindow.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import UIKit

final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else {
            return nil
        }
        return rootViewController?.view == hitView ? nil : hitView
    }
}
