extension Swift.Sequence {
    /// Tests every element, stopping at the first rejection.
    /// A single-pass sequence is advanced by evaluation.
    @inlinable
    public func allSatisfy(_ predicate: Predicate<Element>) -> Bool {
        allSatisfy(predicate.evaluate)
    }

    /// Tests for a matching element, stopping at the first match.
    @inlinable
    public func contains(where predicate: Predicate<Element>) -> Bool {
        contains(where: predicate.evaluate)
    }

    /// Returns the first matching element, advancing only as far as needed.
    @inlinable
    public func first(where predicate: Predicate<Element>) -> Element? {
        first(where: predicate.evaluate)
    }
}
