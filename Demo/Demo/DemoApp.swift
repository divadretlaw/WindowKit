//
//  DemoApp.swift
//  Demo
//
//  Created by David Walter on 14.10.23.
//

import SwiftUI
import WindowKit

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            WindowSceneReader { _ in
                ContentView()
            }
        }
    }
}
