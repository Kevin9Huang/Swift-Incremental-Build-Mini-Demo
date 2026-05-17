// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftIncrementalBuildMiniDemo",
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: ["LibraryModule"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency=complete")
            ]),
        .target(
            name: "LibraryModule",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency=complete")
            ]),
    ]
)
