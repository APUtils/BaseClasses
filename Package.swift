// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BaseClasses",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
    ],
    products: [
        .library(
            name: "BaseClasses",
            targets: ["BaseClasses"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BaseClasses",
            dependencies: [],
            path: "BaseClasses/Classes",
            exclude: []),
    ]
)
