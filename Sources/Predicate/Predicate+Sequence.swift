extension Predicate {

    @inlinable
    public static func forAll<S: Swift.Sequence>(_ predicate: Predicate) -> Predicate<S>
    where S.Element == T {
        Predicate<S> { $0.allSatisfy(predicate) }
    }

    @inlinable
    public static func forAny<S: Swift.Sequence>(_ predicate: Predicate) -> Predicate<S>
    where S.Element == T {
        Predicate<S> { $0.contains(where: predicate) }
    }

    @inlinable
    public static func forNone<S: Swift.Sequence>(_ predicate: Predicate) -> Predicate<S>
    where S.Element == T {
        Predicate<S> { !$0.contains(where: predicate) }
    }

    @inlinable
    public func forAll<S: Swift.Sequence>() -> Predicate<S> where S.Element == T {
        Self.forAll(self)
    }

    @inlinable
    public func forAny<S: Swift.Sequence>() -> Predicate<S> where S.Element == T {
        Self.forAny(self)
    }

    @inlinable
    public func forNone<S: Swift.Sequence>() -> Predicate<S> where S.Element == T {
        Self.forNone(self)
    }
}
