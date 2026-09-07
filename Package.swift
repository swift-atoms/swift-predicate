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

        .library(name: "Predicate Foundation Integration", targets: ["Predicate Foundation Integration"]),
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
            name: "Predicate Foundation Integration",
            dependencies: [
                .target(name: "Predicate"),
            ],
            path: "Sources/Predicate Foundation Integration"
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
                .target(name: "Predicate Foundation Integration"),
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
