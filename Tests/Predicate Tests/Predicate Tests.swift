import Testing

import Predicate

@Suite
struct `Predicates evaluate supplied closures and constant truth values` {
    @Test
    func `Predicate construction evaluates the supplied closure`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }

        #expect(isEven(4) == true)
        #expect(isEven(3) == false)
        #expect(isEven.evaluate(4) == true)
    }


}

@Suite
struct `Predicate ownership and iteration contracts` {
    private struct Owned: ~Copyable { let value: Int }

    @Test func `Boolean composition repeatedly borrows a noncopyable value`() {
        let positive = Predicate<Owned> { $0.value > 0 }
        let even = Predicate<Owned> { $0.value % 2 == 0 }
        let predicate = positive && even
        let value = Owned(value: 2)
        let first = predicate(value)
        let second = predicate(value)
        let negated = (!predicate)(value)
        #expect(first)
        #expect(second)
        #expect(!negated)
    }

    @Test func `Boolean composition accepts scoped input`() {
        let values = [1, 2]
        let nonempty = Predicate<Span<Int>> { !$0.isEmpty }
        let pair = Predicate<Span<Int>> { $0.count == 2 }
        let result = (nonempty && pair)(values.span)
        #expect(result)
    }


}
