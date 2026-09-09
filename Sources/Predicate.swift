public struct Predicate<T: ~Copyable & ~Escapable> {

    public var evaluate: (borrowing T) -> Bool

    @inlinable
    public init(_ evaluate: @escaping (borrowing T) -> Bool) {
        self.evaluate = evaluate
    }
}

extension Predicate where T: ~Copyable & ~Escapable {

    @inlinable
    public func callAsFunction(_ value: borrowing T) -> Bool {
        evaluate(value)
    }
}
