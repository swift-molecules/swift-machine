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
        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ordinal.git", branch: "main"),
        .package(
            url: "https://github.com/swift-molecules/swift-graph.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Machine",
            dependencies: [
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Graph", package: "swift-graph")
            ]
        ),
        .target(
            name: "Machine Standard Library Integration",
            dependencies: [.target(name: "Machine")]
        ),
        .target(
            name: "Machine Apple Foundation Integration",
            dependencies: [
                .target(name: "Machine"),
                .target(name: "Machine Standard Library Integration"),
            ]
        ),
        .testTarget(
            name: "Machine Tests",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Graph", package: "swift-graph"),.target(name: "Machine")]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
