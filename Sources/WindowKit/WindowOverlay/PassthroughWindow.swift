//
//  PassthroughWindow.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import UIKit

final class PassthroughWindow: UIWindow {
    var allowNextRootHit = false
    
    // On root view hit this method will be called twice
    //
    // First we hit the view we want to actually hit and
    // then right after the root view.
    // Usually we want to pass the root view hit through,
    // unless we hit the view we actually want to hit before.
    //
    // If we would prevent all root view hits, it would also
    // prevent the hit of the view we want to hit.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else {
            return nil
        }
        
        guard let rootView = rootViewController?.view else {
            return hitView
        }
        
        if #available(iOS 26, *) {
            return rootView.layer.hitTest(point)?.name == nil ? rootView : nil
        }
        
        defer {
            allowNextRootHit = rootView.subviews.contains(hitView)
        }
        
        if rootView == hitView {
            return allowNextRootHit ? rootView : nil
        } else {
            return hitView
        }
    }
}
