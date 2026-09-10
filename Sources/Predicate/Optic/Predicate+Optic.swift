#if Optic
public import Optic

extension Predicate where T: ~Copyable & ~Escapable {

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
