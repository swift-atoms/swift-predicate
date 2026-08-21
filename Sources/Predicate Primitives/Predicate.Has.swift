extension Predicate {

    public struct Has {
        @usableFromInline
        init() {}
    }

    public static var has: Has.Type { Has.self }
}

extension Predicate.Has where T: StringProtocol {

    @inlinable
    public static func prefix(_ prefix: String) -> Predicate<T> {
        Predicate { $0.hasPrefix(prefix) }
    }

    @inlinable
    public static func suffix(_ suffix: String) -> Predicate<T> {
        Predicate { $0.hasSuffix(suffix) }
    }
}

extension Predicate.Has where T: Collection {

    @inlinable
    public static func count(_ count: Int) -> Predicate<T> {
        Predicate { $0.count == count }
    }
}

extension Predicate.Has where T: Identifiable {

    @inlinable
    public static func id(_ id: T.ID) -> Predicate<T> {
        Predicate { $0.id == id }
    }

    @inlinable
    public static func id<C: Collection>(in ids: C) -> Predicate<T> where C.Element == T.ID {
        Predicate { ids.contains($0.id) }
    }
}
