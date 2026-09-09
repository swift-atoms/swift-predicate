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
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Predicate",
            dependencies: [],
            path: "Sources/Predicate"
        ),

        .testTarget(
            name: "Predicate Tests",
            dependencies: [
                .target(name: "Predicate"),
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
