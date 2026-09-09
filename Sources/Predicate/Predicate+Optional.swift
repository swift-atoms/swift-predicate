extension Predicate {

    @inlinable
    public static func optional(_ predicate: Predicate, default defaultValue: Bool) -> Predicate<T?>
    {
        Predicate<T?> { value in
            guard let value else { return defaultValue }
            return predicate.evaluate(value)
        }
    }

    @inlinable
    public func optional(default defaultValue: Bool) -> Predicate<T?> {
        Self.optional(self, default: defaultValue)
    }
}
