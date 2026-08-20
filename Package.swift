// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-machine-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        // MARK: - Namespace
        .library(
            name: "Machine Primitive",
            targets: ["Machine Primitive"]
        ),
        .library(
            name: "Machine Primitives",
            targets: ["Machine Primitives"]
        ),
        .library(
            name: "Machine Value Primitives",
            targets: ["Machine Value Primitives"]
        ),
        .library(
            name: "Machine Capture Primitives",
            targets: ["Machine Capture Primitives"]
        ),
        .library(
            name: "Machine Transform Primitives",
            targets: ["Machine Transform Primitives"]
        ),
        .library(
            name: "Machine Combine Primitives",
            targets: ["Machine Combine Primitives"]
        ),
        .library(
            name: "Machine Next Primitives",
            targets: ["Machine Next Primitives"]
        ),
        .library(
            name: "Machine Finalize Primitives",
            targets: ["Machine Finalize Primitives"]
        ),
        .library(
            name: "Machine Frame Primitives",
            targets: ["Machine Frame Primitives"]
        ),
        .library(
            name: "Machine Node Primitives",
            targets: ["Machine Node Primitives"]
        ),
        .library(
            name: "Machine Program Primitives",
            targets: ["Machine Program Primitives"]
        ),
        .library(
            name: "Machine Convenience Primitives",
            targets: ["Machine Convenience Primitives"]
        ),
        .library(
            name: "Machine Primitives Test Support",
            targets: ["Machine Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-graph-primitives.git",
            branch: "main"
        )
    ],
    targets: [
        // MARK: - Namespace
        .target(
            name: "Machine Primitive",
            dependencies: []
        ),

        // MARK: - Value & Capture

        .target(
            name: "Machine Value Primitives",
            dependencies: [
                .target(name: "Machine Primitive")
            ]
        ),
        .target(
            name: "Machine Capture Primitives",
            dependencies: [
                .target(name: "Machine Primitive")
            ]
        ),

        // MARK: - Carriers

        .target(
            name: "Machine Transform Primitives",
            dependencies: [
                .target(name: "Machine Value Primitives"),
                .target(name: "Machine Capture Primitives"),
            ]
        ),
        .target(
            name: "Machine Combine Primitives",
            dependencies: [
                .target(name: "Machine Value Primitives"),
                .target(name: "Machine Capture Primitives"),
            ]
        ),
        .target(
            name: "Machine Next Primitives",
            dependencies: [
                .target(name: "Machine Value Primitives"),
                .target(name: "Machine Capture Primitives"),
            ]
        ),
        .target(
            name: "Machine Finalize Primitives",
            dependencies: [
                .target(name: "Machine Value Primitives"),
                .target(name: "Machine Capture Primitives"),
            ]
        ),

        // MARK: - Composition

        .target(
            name: "Machine Frame Primitives",
            dependencies: [
                .target(name: "Machine Value Primitives"),
                .target(name: "Machine Transform Primitives"),
                .target(name: "Machine Combine Primitives"),
                .target(name: "Machine Next Primitives"),
                .target(name: "Machine Finalize Primitives"),
            ]
        ),
        .target(
            name: "Machine Node Primitives",
            dependencies: [
                .target(name: "Machine Value Primitives"),
                .target(name: "Machine Transform Primitives"),
                .target(name: "Machine Combine Primitives"),
                .target(name: "Machine Next Primitives"),
                .target(name: "Machine Finalize Primitives"),
                // Node.ID = Graph.Node, Adjacency.Extract — declared directly per [MOD-038]
                // (previously reached transitively via the dissolved Core funnel).
                .product(name: "Graph Sequential Primitives", package: "swift-graph-primitives"),
            ]
        ),
        .target(
            name: "Machine Program Primitives",
            dependencies: [
                .target(name: "Machine Node Primitives"),
                .target(name: "Machine Capture Primitives"),
                // Program/Builder use Graph.Sequential storage directly per [MOD-038]
                // (previously reached transitively via the dissolved Core funnel).
                .product(name: "Graph Sequential Primitives", package: "swift-graph-primitives"),
            ]
        ),

        // MARK: - Convenience

        .target(
            name: "Machine Convenience Primitives",
            dependencies: [
                .target(name: "Machine Program Primitives")
            ]
        ),

        // MARK: - Umbrella

        .target(
            name: "Machine Primitives",
            dependencies: [
                .target(name: "Machine Primitive"),
                .target(name: "Machine Value Primitives"),
                .target(name: "Machine Capture Primitives"),
                .target(name: "Machine Transform Primitives"),
                .target(name: "Machine Combine Primitives"),
                .target(name: "Machine Next Primitives"),
                .target(name: "Machine Finalize Primitives"),
                .target(name: "Machine Frame Primitives"),
                .target(name: "Machine Node Primitives"),
                .target(name: "Machine Program Primitives"),
                .target(name: "Machine Convenience Primitives"),
                // Narrowed to Graph Primitives: the Machine umbrella only ever
                // surfaces Graph.Node/Adjacency/Sequential/Analyze (all in Core).
                // Depending on the full Graph umbrella over-broadly re-exported the
                // graph algorithms + their data-structure cohort ([MOD-006]/[MOD-015]).
                .product(name: "Graph Sequential Primitives", package: "swift-graph-primitives"),
            ]
        ),

        // MARK: - Tests

        .testTarget(
            name: "Machine Value Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),
        .testTarget(
            name: "Machine Combine Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),
        .testTarget(
            name: "Machine Transform Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),
        .testTarget(
            name: "Machine Next Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),
        .testTarget(
            name: "Machine Finalize Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),
        .testTarget(
            name: "Machine Frame Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),
        .testTarget(
            name: "Machine Node Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),
        .testTarget(
            name: "Machine Program Primitives Tests",
            dependencies: [.target(name: "Machine Primitives")]
        ),

        // MARK: - Test Support
        .target(
            name: "Machine Primitives Test Support",
            dependencies: [
                .target(name: "Machine Primitives"),
                .product(name: "Graph Primitives Test Support", package: "swift-graph-primitives"),
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
