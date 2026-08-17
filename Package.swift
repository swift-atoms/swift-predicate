// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-predicate-primitives",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27")
    ],
    products: [
        .library(
            name: "Predicate Primitives",
            targets: ["Predicate Primitives"]
        ),
        .library(
            name: "Predicate Primitives Test Support",
            targets: ["Predicate Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-logic-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Predicate Primitives",
            dependencies: [
                .product(name: "Logic Ternary Primitives", package: "swift-logic-primitives"),
            ]
        ),
        .target(
            name: "Predicate Primitives Test Support",
            dependencies: [
                "Predicate Primitives",
                .product(name: "Logic Primitives Test Support", package: "swift-logic-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Predicate Primitives Tests",
            dependencies: [
                "Predicate Primitives",
                .product(name: "Logic Ternary Primitives", package: "swift-logic-primitives"),
                "Predicate Primitives Test Support",
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
