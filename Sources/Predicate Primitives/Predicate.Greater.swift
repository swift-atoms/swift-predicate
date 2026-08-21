extension Predicate {

    public struct Greater {
        @usableFromInline
        init() {}
    }

    public static var greater: Greater.Type { Greater.self }
}

extension Predicate.Greater where T: Comparable {

    @inlinable
    public static func than(_ value: T) -> Predicate<T> {
        Predicate { $0 > value }
    }

    @inlinable
    public static func thanOrEqualTo(_ value: T) -> Predicate<T> {
        Predicate { $0 >= value }
    }
}
