extension Predicate {

    public struct Equal {
        @usableFromInline
        init() {}
    }

    public static var equal: Equal.Type { Equal.self }
}

extension Predicate.Equal where T: Equatable {

    @inlinable
    public static func to(_ value: T) -> Predicate<T> {
        Predicate { $0 == value }
    }

    @inlinable
    public static func toAny(of values: T...) -> Predicate<T> {
        Predicate { values.contains($0) }
    }

    @inlinable
    public static func toNone(of values: T...) -> Predicate<T> {
        Predicate { !values.contains($0) }
    }
}
