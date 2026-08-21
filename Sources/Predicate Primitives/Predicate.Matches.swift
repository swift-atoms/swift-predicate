extension Predicate {

    public struct Matches {
        @usableFromInline
        init() {}
    }

    public static var matches: Matches.Type { Matches.self }
}

extension Predicate.Matches where T: StringProtocol {

    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    @inlinable
    public static func regex(_ regex: Regex<Substring>) -> Predicate<T> {

        Predicate { (try? regex.wholeMatch(in: String($0))) != nil }
    }
}
