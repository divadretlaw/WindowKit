// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WindowKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "WindowKit",
            targets: ["WindowKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/WindowSceneReader", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "WindowKit",
            dependencies: ["WindowSceneReader"]
        )
    ]
)
