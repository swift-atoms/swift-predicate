extension Predicate {

    public struct Count {
        @usableFromInline
        let predicate: Predicate

        @usableFromInline
        init(_ predicate: Predicate) {
            self.predicate = predicate
        }
    }

    @inlinable
    public var count: Count { Count(self) }
}

extension Predicate.Count {

    @inlinable
    public static func atLeast(_ predicate: Predicate, _ n: Int) -> Predicate<[T]> {
        Predicate<[T]> { array in
            var count = 0
            for element in array {
                if predicate.evaluate(element) {
                    count += 1
                    if count >= n { return true }
                }
            }
            return false
        }
    }

    @inlinable
    public static func atMost(_ predicate: Predicate, _ n: Int) -> Predicate<[T]> {
        Predicate<[T]> { array in
            var count = 0
            for element in array {
                if predicate.evaluate(element) {
                    count += 1
                    if count > n { return false }
                }
            }
            return true
        }
    }

    @inlinable
    public static func exactly(_ predicate: Predicate, _ n: Int) -> Predicate<[T]> {
        Predicate<[T]> { array in
            var count = 0
            for element in array {
                if predicate.evaluate(element) {
                    count += 1
                    if count > n { return false }
                }
            }
            return count == n
        }
    }

    @inlinable
    public static func zero(_ predicate: Predicate) -> Predicate<[T]> {
        Self.exactly(predicate, 0)
    }

    @inlinable
    public static func one(_ predicate: Predicate) -> Predicate<[T]> {
        Self.exactly(predicate, 1)
    }

    @inlinable
    public func atLeast(_ n: Int) -> Predicate<[T]> {
        Self.atLeast(self.predicate, n)
    }

    @inlinable
    public func atMost(_ n: Int) -> Predicate<[T]> {
        Self.atMost(self.predicate, n)
    }

    @inlinable
    public func exactly(_ n: Int) -> Predicate<[T]> {
        Self.exactly(self.predicate, n)
    }

    @inlinable
    public var zero: Predicate<[T]> {
        Self.zero(self.predicate)
    }

    @inlinable
    public var one: Predicate<[T]> {
        Self.one(self.predicate)
    }
}
