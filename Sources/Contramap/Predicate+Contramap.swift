#if Contramap
public import Contramap

extension Predicate where T: ~Copyable & ~Escapable {
    /// Projects once, then borrows the projected value for predicate evaluation.
    @inlinable
    public init<Focus: ~Copyable>(
        _ projection: Contramap<T, Focus, Never>,
        satisfying predicate: Predicate<Focus>
    ) {
        self.init { source in
            let projected = projection(source)
            return predicate(projected)
        }
    }
}

extension Predicate where T: ~Copyable {
    @inlinable
    public static func pullback<U: ~Copyable & ~Escapable>(
        _ predicate: Predicate,
        _ project: @escaping (borrowing U) -> T
    ) -> Predicate<U> {
        Predicate<U>(Contramap<U, T, Never>(project), satisfying: predicate)
    }

    @inlinable
    public func pullback<U: ~Copyable & ~Escapable>(
        _ project: @escaping (borrowing U) -> T
    ) -> Predicate<U> {
        Self.pullback(self, project)
    }
}

extension Predicate {
    @inlinable
    public static func pullback<U>(_ predicate: Predicate, _ keyPath: KeyPath<U, T>) -> Predicate<U> {
        Self.pullback(predicate) { $0[keyPath: keyPath] }
    }

    @inlinable
    public func pullback<U>(_ keyPath: KeyPath<U, T>) -> Predicate<U> {
        Self.pullback(self, keyPath)
    }
}
#endif
