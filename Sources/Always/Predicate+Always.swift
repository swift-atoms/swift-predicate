#if Always
public import Always

extension Predicate where T: ~Copyable & ~Escapable {
    @inlinable
    public init(_ constant: Always<Bool>) {
        self.init { _ in constant.value }
    }

    @inlinable
    public static var always: Predicate { .init(Always(true)) }

    @inlinable
    public static var never: Predicate { .init(Always(false)) }
}
#endif
