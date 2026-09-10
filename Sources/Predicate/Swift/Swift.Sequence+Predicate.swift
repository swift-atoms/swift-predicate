extension Swift.Sequence {

    @inlinable
    public func allSatisfy(_ predicate: Predicate<Element>) -> Bool {
        allSatisfy(predicate.evaluate)
    }

    @inlinable
    public func contains(where predicate: Predicate<Element>) -> Bool {
        contains(where: predicate.evaluate)
    }

    @inlinable
    public func first(where predicate: Predicate<Element>) -> Element? {
        first(where: predicate.evaluate)
    }
}
