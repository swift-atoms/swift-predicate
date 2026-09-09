#if Optic
public import Optic

extension Predicate where T: ~Copyable & ~Escapable {
    /// Universal evaluation. No visits satisfy the predicate vacuously.
    /// The visitor cannot stop traversal, but the predicate stops after rejection.
    public init<
        Target: ~Copyable & ~Escapable,
        Focus: ~Copyable & ~Escapable,
        Replacement: ~Copyable & ~Escapable
    >(
        allSatisfying predicate: Predicate<Focus>,
        in fold: Optic<T, Target, Focus, Replacement>.Fold
    ) {
        self.init { source in
            var accepted = true
            _ = fold(source) { focus in
                if accepted { accepted = predicate(focus) }
            }
            return accepted
        }
    }

    /// Existential evaluation. No visits return false.
    /// The visitor cannot stop traversal, but the predicate stops after a match.
    public init<
        Target: ~Copyable & ~Escapable,
        Focus: ~Copyable & ~Escapable,
        Replacement: ~Copyable & ~Escapable
    >(
        anySatisfying predicate: Predicate<Focus>,
        in fold: Optic<T, Target, Focus, Replacement>.Fold
    ) {
        self.init { source in
            var accepted = false
            _ = fold(source) { focus in
                if !accepted { accepted = predicate(focus) }
            }
            return accepted
        }
    }
}
#endif
