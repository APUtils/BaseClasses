// swift-tools-version:5.0
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
        .package(url: "https://github.com/APUtils/LogsManager.git", .upToNextMajor(from: "9.1.14")),
    ],
    targets: [
        .target(
            name: "BaseClasses",
            dependencies: [
                "RoutableLogger",
            ],
            path: "BaseClasses/Classes",
            exclude: []),
    ]
)
