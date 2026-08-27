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
            name: "Machine Primitive",
            targets: ["Machine Primitive"]
        ),
        .library(
            name: "Machine",
            targets: ["Machine"]
        ),
        .library(
            name: "Machine Value",
            targets: ["Machine Value"]
        ),
        .library(
            name: "Machine Capture",
            targets: ["Machine Capture"]
        ),
        .library(
            name: "Machine Transform",
            targets: ["Machine Transform"]
        ),
        .library(
            name: "Machine Combine",
            targets: ["Machine Combine"]
        ),
        .library(
            name: "Machine Next",
            targets: ["Machine Next"]
        ),
        .library(
            name: "Machine Finalize",
            targets: ["Machine Finalize"]
        ),
        .library(
            name: "Machine Frame",
            targets: ["Machine Frame"]
        ),
        .library(
            name: "Machine Node",
            targets: ["Machine Node"]
        ),
        .library(
            name: "Machine Program",
            targets: ["Machine Program"]
        ),
        .library(
            name: "Machine Convenience",
            targets: ["Machine Convenience"]
        ),
        .library(
            name: "Machine Test Support",
            targets: ["Machine Test Support"]
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
            name: "Machine Primitive",
            dependencies: []
        ),

        .target(
            name: "Machine Value",
            dependencies: [
                .target(name: "Machine Primitive")
            ]
        ),
        .target(
            name: "Machine Capture",
            dependencies: [
                .target(name: "Machine Primitive")
            ]
        ),

        .target(
            name: "Machine Transform",
            dependencies: [
                .target(name: "Machine Value"),
                .target(name: "Machine Capture"),
            ]
        ),
        .target(
            name: "Machine Combine",
            dependencies: [
                .target(name: "Machine Value"),
                .target(name: "Machine Capture"),
            ]
        ),
        .target(
            name: "Machine Next",
            dependencies: [
                .target(name: "Machine Value"),
                .target(name: "Machine Capture"),
            ]
        ),
        .target(
            name: "Machine Finalize",
            dependencies: [
                .target(name: "Machine Value"),
                .target(name: "Machine Capture"),
            ]
        ),

        .target(
            name: "Machine Frame",
            dependencies: [
                .target(name: "Machine Value"),
                .target(name: "Machine Transform"),
                .target(name: "Machine Combine"),
                .target(name: "Machine Next"),
                .target(name: "Machine Finalize"),
            ]
        ),
        .target(
            name: "Machine Node",
            dependencies: [
                .target(name: "Machine Value"),
                .target(name: "Machine Transform"),
                .target(name: "Machine Combine"),
                .target(name: "Machine Next"),
                .target(name: "Machine Finalize"),

                .product(name: "Graph Sequential", package: "swift-graph"),
            ]
        ),
        .target(
            name: "Machine Program",
            dependencies: [
                .target(name: "Machine Node"),
                .target(name: "Machine Capture"),

                .product(name: "Graph Sequential", package: "swift-graph"),
            ]
        ),

        .target(
            name: "Machine Convenience",
            dependencies: [
                .target(name: "Machine Program")
            ]
        ),

        .target(
            name: "Machine",
            dependencies: [
                .target(name: "Machine Primitive"),
                .target(name: "Machine Value"),
                .target(name: "Machine Capture"),
                .target(name: "Machine Transform"),
                .target(name: "Machine Combine"),
                .target(name: "Machine Next"),
                .target(name: "Machine Finalize"),
                .target(name: "Machine Frame"),
                .target(name: "Machine Node"),
                .target(name: "Machine Program"),
                .target(name: "Machine Convenience"),

                .product(name: "Graph Sequential", package: "swift-graph"),
            ]
        ),

        .testTarget(
            name: "Machine Value Tests",
            dependencies: [.target(name: "Machine")]
        ),
        .testTarget(
            name: "Machine Combine Tests",
            dependencies: [.target(name: "Machine")]
        ),
        .testTarget(
            name: "Machine Transform Tests",
            dependencies: [.target(name: "Machine")]
        ),
        .testTarget(
            name: "Machine Next Tests",
            dependencies: [.target(name: "Machine")]
        ),
        .testTarget(
            name: "Machine Finalize Tests",
            dependencies: [.target(name: "Machine")]
        ),
        .testTarget(
            name: "Machine Frame Tests",
            dependencies: [.target(name: "Machine")]
        ),
        .testTarget(
            name: "Machine Node Tests",
            dependencies: [.target(name: "Machine")]
        ),
        .testTarget(
            name: "Machine Program Tests",
            dependencies: [.target(name: "Machine")]
        ),

        .target(
            name: "Machine Test Support",
            dependencies: [
                .target(name: "Machine"),
                .product(name: "Graph Test Support", package: "swift-graph"),
            ],
            path: "Tests/Support"
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
