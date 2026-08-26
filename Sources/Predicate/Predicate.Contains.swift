extension Predicate {

    public struct Contains {
        @usableFromInline
        init() {}
    }

    public static var contains: Contains.Type { Contains.self }
}

extension Predicate.Contains where T: StringProtocol {

    @inlinable
    public static func substring(_ substring: String) -> Predicate<T> {
        Predicate { $0.contains(substring) }
    }

    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @inlinable
    public static func match(_ regex: Regex<Substring>) -> Predicate<T> {

        Predicate { (try? regex.firstMatch(in: String($0))) != nil }
    }
}
