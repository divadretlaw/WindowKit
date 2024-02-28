// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WindowKit",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "WindowKit",
            targets: ["WindowKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/WindowSceneReader", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "WindowKit",
            dependencies: ["WindowSceneReader"]
        )
    ]
)
