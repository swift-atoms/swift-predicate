extension Predicate {

    public struct Not {
        @usableFromInline
        init() {}
    }

    public static var not: Not.Type { Not.self }
}

extension Predicate.Not where T: Equatable {

    @inlinable
    public static func equalTo(_ value: T) -> Predicate<T> {
        Predicate { $0 != value }
    }
}

extension Predicate.Not where T: Comparable {

    @inlinable
    public static func inRange(_ range: ClosedRange<T>) -> Predicate<T> {
        Predicate { !range.contains($0) }
    }

    @inlinable
    public static func inRange(_ range: Range<T>) -> Predicate<T> {
        Predicate { !range.contains($0) }
    }
}
