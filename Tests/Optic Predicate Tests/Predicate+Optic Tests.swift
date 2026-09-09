#if Optic
import Predicate
import Testing

@Suite struct `Optics evaluate borrowed focuses` {
    private struct Owned: ~Copyable { let value: Int }

    @Test func `a borrowed fold evaluates noncopyable source and focus repeatedly`() {
        let fold = Optic<Owned, Owned, Owned, Owned>.Fold.identity
        let test = Predicate(allSatisfying: Predicate { $0.value > 0 }, in: fold)
        let value = Owned(value: 1)
        let first = test(value)
        let second = test(value)
        #expect(first && second)
    }

    @Test func `fold integration supports scoped focuses`() {
        let fold = Optic<Span<Int>, Span<Int>, Span<Int>, Span<Int>>.Fold.identity
        let test = Predicate(anySatisfying: Predicate { $0.count == 2 }, in: fold)
        let values = [1, 2]
        let result = test(values.span)
        #expect(result)
    }

    @Test func `empty and multiple visits have explicit quantifier semantics`() {
        var visits = 0
        var evaluations = 0
        let fold = Optic<[Int], [Int], Int, Int>.Fold { values, visit in
            for value in values { visits += 1; visit(value) }
            return !values.isEmpty
        }
        let positive = Predicate<Int> { evaluations += 1; return $0 > 0 }
        #expect(Predicate(allSatisfying: positive, in: fold)([]))
        #expect(!Predicate(anySatisfying: positive, in: fold)([]))
        #expect(evaluations == 0)
        #expect(!Predicate(allSatisfying: positive, in: fold)([1, 0, 2]))
        #expect(visits == 3)
        #expect(evaluations == 2)
        visits = 0
        evaluations = 0
        #expect(Predicate(anySatisfying: positive, in: fold)([0, 1, 2]))
        #expect(visits == 3)
        #expect(evaluations == 2)
    }

    @Test func `existing lens and prism convert through the borrowed fold`() {
        struct User { let age: Int }
        let lens = Optic<User, User, Int, Int>.Lens { user in
            (user.age, { User(age: $0) })
        }
        let adult = Predicate(
            allSatisfying: Predicate { $0 >= 18 },
            in: Optic<User, User, Int, Int>.Fold(lens)
        )
        #expect(adult(User(age: 21)))
        #expect(!adult(User(age: 12)))

        let prism = Optic<Int?, Int?, Int, Int>.Prism(
            embed: { .some($0) }, extract: { $0 }
        )
        let presentPositive = Predicate(
            anySatisfying: Predicate { $0 > 0 },
            in: Optic<Int?, Int?, Int, Int>.Fold(prism)
        )
        #expect(!presentPositive(nil))
        #expect(presentPositive(1))
        #expect(!presentPositive(-1))
    }
}
#endif
