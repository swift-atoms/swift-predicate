public struct Predicate<T> {

    public var evaluate: (T) -> Bool

    @inlinable
    public init(_ evaluate: @escaping (T) -> Bool) {
        self.evaluate = evaluate
    }
}

extension Predicate {

    @inlinable
    public static func callAsFunction(_ predicate: Predicate, _ value: T) -> Bool {
        predicate.evaluate(value)
    }

    @inlinable
    public func callAsFunction(_ value: T) -> Bool {
        Self.callAsFunction(self, value)
    }
}

extension Predicate {

    @inlinable
    public static var always: Predicate {
        Predicate { _ in true }
    }

    @inlinable
    public static var never: Predicate {
        Predicate { _ in false }
    }
}

extension Predicate {

    @inlinable
    public static func negated(_ predicate: Predicate) -> Predicate {
        Predicate { !predicate.evaluate($0) }
    }

    @inlinable
    public var negated: Predicate {
        Self.negated(self)
    }

    @inlinable
    public static prefix func ! (predicate: Predicate) -> Predicate {
        Self.negated(predicate)
    }
}

extension Predicate {

    @inlinable
    public static func and(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { lhs.evaluate($0) && rhs.evaluate($0) }
    }

    @inlinable
    public func and(_ other: Predicate) -> Predicate {
        Self.and(self, other)
    }

    @inlinable
    public static func && (lhs: Predicate, rhs: Predicate) -> Predicate {
        Self.and(lhs, rhs)
    }
}

extension Predicate {

    @inlinable
    public static func or(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { lhs.evaluate($0) || rhs.evaluate($0) }
    }

    @inlinable
    public func or(_ other: Predicate) -> Predicate {
        Self.or(self, other)
    }

    @inlinable
    public static func || (lhs: Predicate, rhs: Predicate) -> Predicate {
        Self.or(lhs, rhs)
    }
}

extension Predicate {

    @inlinable
    public static func xor(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { lhs.evaluate($0) != rhs.evaluate($0) }
    }

    @inlinable
    public func xor(_ other: Predicate) -> Predicate {
        Self.xor(self, other)
    }

    @inlinable
    public static func ^ (lhs: Predicate, rhs: Predicate) -> Predicate {
        Self.xor(lhs, rhs)
    }
}

extension Predicate {

    @inlinable
    public static func nand(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { !lhs.evaluate($0) || !rhs.evaluate($0) }
    }

    @inlinable
    public static func nor(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { !lhs.evaluate($0) && !rhs.evaluate($0) }
    }

    @inlinable
    public func nand(_ other: Predicate) -> Predicate {
        Self.nand(self, other)
    }

    @inlinable
    public func nor(_ other: Predicate) -> Predicate {
        Self.nor(self, other)
    }
}

extension Predicate {

    @inlinable
    public static func implies(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Self.or(Self.negated(lhs), rhs)
    }

    @inlinable
    public static func iff(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Self.negated(Self.xor(lhs, rhs))
    }

    @inlinable
    public static func unless(_ lhs: Predicate, condition: Predicate) -> Predicate {
        Self.implies(condition, lhs)
    }

    @inlinable
    public func implies(_ other: Predicate) -> Predicate {
        Self.implies(self, other)
    }

    @inlinable
    public func iff(_ other: Predicate) -> Predicate {
        Self.iff(self, other)
    }

    @inlinable
    public func unless(_ condition: Predicate) -> Predicate {
        Self.unless(self, condition: condition)
    }
}

extension Predicate {

    @inlinable
    public static func pullback<U>(
        _ predicate: Predicate,
        _ transform: @escaping (U) -> T
    ) -> Predicate<U> {
        Predicate<U> { predicate.evaluate(transform($0)) }
    }

    @inlinable
    public static func pullback<U>(_ predicate: Predicate, _ keyPath: KeyPath<U, T>) -> Predicate<U>
    {
        Self.pullback(predicate) { $0[keyPath: keyPath] }
    }

    @inlinable
    public func pullback<U>(_ transform: @escaping (U) -> T) -> Predicate<U> {
        Self.pullback(self, transform)
    }

    @inlinable
    public func pullback<U>(_ keyPath: KeyPath<U, T>) -> Predicate<U> {
        Self.pullback(self, keyPath)
    }
}

extension Predicate {

    @inlinable
    public static func `where`<V>(_ keyPath: KeyPath<T, V>, _ predicate: Predicate<V>) -> Predicate
    {
        predicate.pullback(keyPath)
    }

    @inlinable
    public static func `where`<V>(
        _ keyPath: KeyPath<T, V>,
        _ test: @escaping (V) -> Bool
    ) -> Predicate {
        Predicate<V>(test).pullback(keyPath)
    }
}

extension Predicate {

    @inlinable
    public static func optional(_ predicate: Predicate, default defaultValue: Bool) -> Predicate<T?>
    {
        Predicate<T?> { value in
            guard let value else { return defaultValue }
            return predicate.evaluate(value)
        }
    }

    @inlinable
    public func optional(default defaultValue: Bool) -> Predicate<T?> {
        Self.optional(self, default: defaultValue)
    }
}

extension Predicate {

    @inlinable
    public static func all(_ predicate: Predicate) -> Predicate<[T]> {
        Predicate<[T]> { $0.allSatisfy(predicate.evaluate) }
    }

    @inlinable
    public static func any(_ predicate: Predicate) -> Predicate<[T]> {
        Predicate<[T]> { $0.contains(where: predicate.evaluate) }
    }

    @inlinable
    public static func none(_ predicate: Predicate) -> Predicate<[T]> {
        Predicate<[T]> { !$0.contains(where: predicate.evaluate) }
    }

    @inlinable
    public static func forAll<S: Sequence>(_ predicate: Predicate) -> Predicate<S>
    where S.Element == T {
        Predicate<S> { $0.allSatisfy(predicate.evaluate) }
    }

    @inlinable
    public static func forAny<S: Sequence>(_ predicate: Predicate) -> Predicate<S>
    where S.Element == T {
        Predicate<S> { $0.contains(where: predicate.evaluate) }
    }

    @inlinable
    public static func forNone<S: Sequence>(_ predicate: Predicate) -> Predicate<S>
    where S.Element == T {
        Predicate<S> { !$0.contains(where: predicate.evaluate) }
    }

    @inlinable
    public var all: Predicate<[T]> {
        Self.all(self)
    }

    @inlinable
    public var any: Predicate<[T]> {
        Self.any(self)
    }

    @inlinable
    public var none: Predicate<[T]> {
        Self.none(self)
    }

    @inlinable
    public func forAll<S: Sequence>() -> Predicate<S> where S.Element == T {
        Self.forAll(self)
    }

    @inlinable
    public func forAny<S: Sequence>() -> Predicate<S> where S.Element == T {
        Self.forAny(self)
    }

    @inlinable
    public func forNone<S: Sequence>() -> Predicate<S> where S.Element == T {
        Self.forNone(self)
    }
}
