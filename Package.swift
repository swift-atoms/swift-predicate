// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-predicate",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Predicate",
            targets: ["Predicate"]
        ),
        .library(
            name: "Predicate Standard Library Integration",
            targets: ["Predicate Standard Library Integration"]
        ),
        .library(
            name: "Predicate Apple Foundation Integration",
            targets: ["Predicate Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Predicate",
            dependencies: []
        ),
        .target(
            name: "Predicate Standard Library Integration",
            dependencies: ["Predicate"]
        ),
        .target(
            name: "Predicate Apple Foundation Integration",
            dependencies: [
                "Predicate",
                "Predicate Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Predicate Tests",
            dependencies: ["Predicate"]
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
