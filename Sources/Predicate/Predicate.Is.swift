extension Predicate {

    public struct Is {
        @usableFromInline
        init() {}
    }

    public static var `is`: Is.Type { Is.self }
}

extension Predicate.Is where T: Collection {

    @inlinable
    public static var empty: Predicate<T> {
        Predicate { $0.isEmpty }
    }

    @inlinable
    public static var notEmpty: Predicate<T> {
        Predicate { !$0.isEmpty }
    }
}

extension Predicate.Is {

    @inlinable
    public static var `nil`: Predicate<T?> {
        Predicate<T?> { $0 == nil }
    }

    @inlinable
    public static var notNil: Predicate<T?> {
        Predicate<T?> { $0 != nil }
    }
}
