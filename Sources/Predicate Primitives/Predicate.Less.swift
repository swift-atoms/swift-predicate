extension Predicate {

    public struct Less {
        @usableFromInline
        init() {}
    }

    public static var less: Less.Type { Less.self }
}

extension Predicate.Less where T: Comparable {

    @inlinable
    public static func than(_ value: T) -> Predicate<T> {
        Predicate { $0 < value }
    }

    @inlinable
    public static func thanOrEqualTo(_ value: T) -> Predicate<T> {
        Predicate { $0 <= value }
    }
}
