@inlinable
public func && <T>(
    lhs: @escaping (T) -> Bool,
    rhs: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate.and(Predicate(lhs), Predicate(rhs))
}

@inlinable
public func || <T>(
    lhs: @escaping (T) -> Bool,
    rhs: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate.or(Predicate(lhs), Predicate(rhs))
}

@inlinable
public func ^ <T>(
    lhs: @escaping (T) -> Bool,
    rhs: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate.xor(Predicate(lhs), Predicate(rhs))
}

@inlinable
public prefix func ! <T>(
    closure: @escaping (T) -> Bool
) -> Predicate<T> {
    Predicate.negated(Predicate(closure))
}

extension Predicate {

    @inlinable
    public static func && (lhs: Predicate, rhs: @escaping (T) -> Bool) -> Predicate {
        Self.and(lhs, Predicate(rhs))
    }

    @inlinable
    public static func && (lhs: @escaping (T) -> Bool, rhs: Predicate) -> Predicate {
        Self.and(Predicate(lhs), rhs)
    }

    @inlinable
    public static func || (lhs: Predicate, rhs: @escaping (T) -> Bool) -> Predicate {
        Self.or(lhs, Predicate(rhs))
    }

    @inlinable
    public static func || (lhs: @escaping (T) -> Bool, rhs: Predicate) -> Predicate {
        Self.or(Predicate(lhs), rhs)
    }

    @inlinable
    public static func ^ (lhs: Predicate, rhs: @escaping (T) -> Bool) -> Predicate {
        Self.xor(lhs, Predicate(rhs))
    }

    @inlinable
    public static func ^ (lhs: @escaping (T) -> Bool, rhs: Predicate) -> Predicate {
        Self.xor(Predicate(lhs), rhs)
    }
}

extension Predicate {

    @inlinable
    public func and(_ closure: @escaping (T) -> Bool) -> Predicate {
        and(Predicate(closure))
    }

    @inlinable
    public func or(_ closure: @escaping (T) -> Bool) -> Predicate {
        or(Predicate(closure))
    }

    @inlinable
    public func xor(_ closure: @escaping (T) -> Bool) -> Predicate {
        xor(Predicate(closure))
    }

    @inlinable
    public func nand(_ closure: @escaping (T) -> Bool) -> Predicate {
        nand(Predicate(closure))
    }

    @inlinable
    public func nor(_ closure: @escaping (T) -> Bool) -> Predicate {
        nor(Predicate(closure))
    }

    @inlinable
    public func implies(_ closure: @escaping (T) -> Bool) -> Predicate {
        implies(Predicate(closure))
    }

    @inlinable
    public func iff(_ closure: @escaping (T) -> Bool) -> Predicate {
        iff(Predicate(closure))
    }

    @inlinable
    public func unless(_ closure: @escaping (T) -> Bool) -> Predicate {
        unless(Predicate(closure))
    }
}
