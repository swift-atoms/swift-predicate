extension Predicate where T: ~Copyable & ~Escapable {

    @inlinable
    public static func negated(_ predicate: Predicate) -> Predicate {
        Predicate { !predicate.evaluate($0) }
    }

    @inlinable
    public var negated: Predicate {
        Self.negated(self)
    }

    @inlinable
    public static prefix func ! (predicate: Predicate) -> Predicate {
        Self.negated(predicate)
    }
}

extension Predicate where T: ~Copyable & ~Escapable {

    @inlinable
    public static func and(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { lhs.evaluate($0) && rhs.evaluate($0) }
    }

    @inlinable
    public func and(_ other: Predicate) -> Predicate {
        Self.and(self, other)
    }

    @inlinable
    public static func && (lhs: Predicate, rhs: Predicate) -> Predicate {
        Self.and(lhs, rhs)
    }
}

extension Predicate where T: ~Copyable & ~Escapable {

    @inlinable
    public static func or(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { lhs.evaluate($0) || rhs.evaluate($0) }
    }

    @inlinable
    public func or(_ other: Predicate) -> Predicate {
        Self.or(self, other)
    }

    @inlinable
    public static func || (lhs: Predicate, rhs: Predicate) -> Predicate {
        Self.or(lhs, rhs)
    }
}

extension Predicate where T: ~Copyable & ~Escapable {

    @inlinable
    public static func xor(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { lhs.evaluate($0) != rhs.evaluate($0) }
    }

    @inlinable
    public func xor(_ other: Predicate) -> Predicate {
        Self.xor(self, other)
    }

    @inlinable
    public static func ^ (lhs: Predicate, rhs: Predicate) -> Predicate {
        Self.xor(lhs, rhs)
    }
}

extension Predicate where T: ~Copyable & ~Escapable {

    @inlinable
    public static func nand(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { !lhs.evaluate($0) || !rhs.evaluate($0) }
    }

    @inlinable
    public static func nor(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Predicate { !lhs.evaluate($0) && !rhs.evaluate($0) }
    }

    @inlinable
    public func nand(_ other: Predicate) -> Predicate {
        Self.nand(self, other)
    }

    @inlinable
    public func nor(_ other: Predicate) -> Predicate {
        Self.nor(self, other)
    }
}

extension Predicate where T: ~Copyable & ~Escapable {

    @inlinable
    public static func implies(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Self.or(Self.negated(lhs), rhs)
    }

    @inlinable
    public static func iff(_ lhs: Predicate, _ rhs: Predicate) -> Predicate {
        Self.negated(Self.xor(lhs, rhs))
    }

    @inlinable
    public func implies(_ other: Predicate) -> Predicate {
        Self.implies(self, other)
    }

    @inlinable
    public func iff(_ other: Predicate) -> Predicate {
        Self.iff(self, other)
    }

}
