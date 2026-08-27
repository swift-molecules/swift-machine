// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-machine",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Machine",
            targets: ["Machine"]
        ),
        .library(
            name: "Machine Standard Library Integration",
            targets: ["Machine Standard Library Integration"]
        ),
        .library(
            name: "Machine Apple Foundation Integration",
            targets: ["Machine Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-graph.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Machine",
            dependencies: [
                .product(name: "Graph Sequential", package: "swift-graph")
            ]
        ),
        .target(
            name: "Machine Standard Library Integration",
            dependencies: ["Machine"]
        ),
        .target(
            name: "Machine Apple Foundation Integration",
            dependencies: [
                "Machine",
                "Machine Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Machine Tests",
            dependencies: ["Machine"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
