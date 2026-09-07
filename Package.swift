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
        .library(name: "Predicate", targets: ["Predicate"]),
        .library(name: "Predicate Standard Library Integration", targets: ["Predicate Standard Library Integration"]),
        .library(name: "Predicate Foundation Library Integration", targets: ["Predicate Foundation Library Integration"]),
        .library(name: "Predicate Test Support", targets: ["Predicate Test Support"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Predicate",
            dependencies: [
            ],
            path: "Sources/Predicate"
        ),
        .target(
            name: "Predicate Standard Library Integration",
            dependencies: [
                .target(name: "Predicate"),
            ],
            path: "Sources/Predicate Standard Library Integration"
        ),
        .target(
            name: "Predicate Foundation Library Integration",
            dependencies: [
                .target(name: "Predicate"),
                .target(name: "Predicate Standard Library Integration"),
            ],
            path: "Sources/Predicate Foundation Library Integration"
        ),
        .target(
            name: "Predicate Test Support",
            dependencies: [
                .target(name: "Predicate"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Predicate Tests",
            dependencies: [
                .target(name: "Predicate"),
                .target(name: "Predicate Test Support"),
                .target(name: "Predicate Standard Library Integration"),
                .target(name: "Predicate Foundation Library Integration"),
            ],
            path: "Tests/Predicate Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
