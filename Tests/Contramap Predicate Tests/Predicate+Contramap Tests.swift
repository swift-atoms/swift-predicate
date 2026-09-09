#if Contramap
import Predicate
import Testing

@Suite
struct `Predicate pullbacks evaluate projected input values` {
    @Test
    func `Static pullback evaluates the value produced by its projection closure`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let hasEvenLength = Predicate.pullback(isEven) { (s: String) in s.count }

        #expect(hasEvenLength("hi") == true)
        #expect(hasEvenLength("hello") == false)
    }

    @Test
    func `Static pullback evaluates the value selected by its key path`() {
        let isLong = Predicate<Int> { $0 > 3 }
        let hasLongCount: Predicate<String> = Predicate.pullback(isLong, \.count)

        #expect(hasLongCount("hi") == false)
        #expect(hasLongCount("hello") == true)
    }

    @Test
    func `Instance pullback evaluates the value produced by its projection closure`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let hasEvenLength = isEven.pullback { (s: String) in s.count }

        #expect(hasEvenLength("hi") == true)
        #expect(hasEvenLength("hello") == false)
    }

    @Test
    func `Instance pullback evaluates the value selected by its key path`() {
        let isLong = Predicate<Int> { $0 > 3 }
        let hasLongCount: Predicate<String> = isLong.pullback(\.count)

        #expect(hasLongCount("hi") == false)
        #expect(hasLongCount("hello") == true)
    }
}

@Suite struct `Predicate input adaptation ownership` {
    private struct Owned: ~Copyable { let value: Int }

    @Test func `pullback borrows noncopyable input and evaluates each stage once`() {
        var projections = 0
        var evaluations = 0
        let test = Predicate<Owned> { evaluations += 1; return $0.value > 0 }
        let adapted = test.pullback { (source: borrowing Owned) in
            projections += 1
            return Owned(value: source.value)
        }
        let source = Owned(value: 1)
        let result = adapted(source)
        #expect(result)
        #expect(source.value == 1)
        #expect(projections == 1)
        #expect(evaluations == 1)
    }

    @Test func `explicit projection adapts a scoped source`() {
        let projection = Contramap { (source: borrowing Span<Int>) in source.count }
        let test = Predicate(projection, satisfying: Predicate { $0 == 2 })
        let values = [1, 2]
        let result = test(values.span)
        #expect(result)
    }
}
#endif
