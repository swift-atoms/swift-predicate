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
            name: "Predicate Test Support",
            targets: ["Predicate Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-logic.git",
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
        .target(
            name: "Predicate Test Support",
            dependencies: [
                "Predicate",
                .product(name: "Logic Test Support", package: "swift-logic"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Predicate Tests",
            dependencies: [
                "Predicate",
                .product(name: "Logic Ternary", package: "swift-logic"),
                "Predicate Test Support",
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
