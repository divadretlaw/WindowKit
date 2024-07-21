//
//  WindowOverlayHostingController.swift
//  WindowKit
//
//  Created by David Walter on 15.10.23.
//

import SwiftUI

final class WindowOverlayHostingController<Content>: UIHostingController<Content>, DynamicProperty where Content: View {
    let key: WindowKey
    let builder: () -> Content
    
    init(key: WindowKey, builder: @escaping () -> Content) {
        self.key = key
        self.builder = builder
        super.init(rootView: builder())
    }
    
    @available(*, unavailable)
    dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
    }
    
    // MARK: - DynamicProperty
    
    nonisolated func update() {
        MainActor.runSync {
            rootView = builder()
        }
    }
}
