# Predicate Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Composable predicate primitives for Swift — a first-class boolean test over values of a type that combines with logical AND, OR, and NOT, so conditions are built as values rather than inline closures. Foundation-free and Embedded-compatible.

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-predicate-primitives.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Predicate Primitives", package: "swift-predicate-primitives")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
