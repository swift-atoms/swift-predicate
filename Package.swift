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
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-logic.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Predicate",
            dependencies: [
                .product(name: "Logic Ternary", package: "swift-logic")
            ]
        ),
        .testTarget(
            name: "Predicate Tests",
            dependencies: [
                .target(name: "Predicate"),
                .product(name: "Logic Ternary", package: "swift-logic"),
            ]
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
