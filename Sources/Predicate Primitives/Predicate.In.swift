extension Predicate {

    public struct In {
        @usableFromInline
        init() {}
    }

    public static var `in`: In.Type { In.self }
}

extension Predicate.In where T: Comparable {

    @inlinable
    public static func range(_ range: ClosedRange<T>) -> Predicate<T> {
        Predicate { range.contains($0) }
    }

    @inlinable
    public static func range(_ range: Range<T>) -> Predicate<T> {
        Predicate { range.contains($0) }
    }
}

extension Predicate.In where T: Equatable {

    @inlinable
    public static func collection<C: Collection>(_ collection: C) -> Predicate<T>
    where C.Element == T {
        Predicate { collection.contains($0) }
    }
}
