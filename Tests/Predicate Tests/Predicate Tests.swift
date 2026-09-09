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

    @Test(arguments: [0, 100, -50])
    func `The always predicate accepts every value`(value: Int) {
        let always = Predicate<Int>.always
        #expect(always(value) == true)
    }

    @Test(arguments: [0, 100, -50])
    func `The never predicate rejects every value`(value: Int) {
        let never = Predicate<Int>.never
        #expect(never(value) == false)
    }

}

@Suite
struct `Predicate conjunction obeys Boolean conjunction laws` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
        (value: -3, expected: false),
    ])
    func `Static predicate AND returns true when both operands match`(value: Int, expected: Bool) {
        let combined = Predicate.and(isEven, isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func `The predicate AND operator returns true when both operands match`(value: Int, expected: Bool) {
        let combined = isEven && isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false),
    ])
    func `Fluent predicate AND returns true when both operands match`(value: Int, expected: Bool) {
        let combined = isEven.and(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func `AND is commutative`() {
        let p1 = isEven && isPositive
        let p2 = isPositive && isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `AND is associative`() {
        let greaterThan5 = Predicate<Int> { $0 > 5 }

        let p1 = (isEven && isPositive) && greaterThan5
        let p2 = isEven && (isPositive && greaterThan5)

        for n in -10...20 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `Conjunction with always preserves the predicate result`() {

        let p = isEven && .always

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `Conjunction with never rejects every value`() {

        let p = isEven && .never

        for n in -10...10 {
            #expect(p(n) == false)
        }
    }
}

@Suite
struct `Predicate disjunction obeys Boolean disjunction laws` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isNegative = Predicate<Int> { $0 < 0 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -3, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: false),
    ])
    func `Static predicate OR returns true when either operand matches`(value: Int, expected: Bool) {
        let combined = Predicate.or(isEven, isNegative)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
    ])
    func `The predicate OR operator returns true when either operand matches`(value: Int, expected: Bool) {
        let combined = isEven || isNegative
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
    ])
    func `Fluent predicate OR returns true when either operand matches`(value: Int, expected: Bool) {
        let combined = isEven.or(isNegative)
        #expect(combined(value) == expected)
    }

    @Test
    func `OR is commutative`() {
        let p1 = isEven || isNegative
        let p2 = isNegative || isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `OR is associative`() {
        let isZero = Predicate<Int> { $0 == 0 }

        let p1 = (isEven || isNegative) || isZero
        let p2 = isEven || (isNegative || isZero)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `Disjunction with never preserves the predicate result`() {

        let p = isEven || .never

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `Disjunction with always accepts every value`() {

        let p = isEven || .always

        for n in -10...10 {
            #expect(p(n) == true)
        }
    }
}

@Suite
struct `Predicate negation obeys involution and complement laws` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `Static predicate negation reverses the predicate result`(value: Int, expected: Bool) {
        let isOdd = Predicate.negated(isEven)
        #expect(isOdd(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `The predicate negation operator reverses the predicate result`(value: Int, expected: Bool) {
        let isOdd = !isEven
        #expect(isOdd(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `The negated property reverses the predicate result`(value: Int, expected: Bool) {
        let isOdd = isEven.negated
        #expect(isOdd(value) == expected)
    }

    @Test
    func `NOT is involution`() {
        let doubleNegated = !(!isEven)

        for n in -10...10 {
            #expect(doubleNegated(n) == isEven(n))
        }
    }

    @Test
    func `A predicate conjoined with its complement rejects every value`() {

        let contradiction = isEven && !isEven

        for n in -10...10 {
            #expect(contradiction(n) == false)
        }
    }

    @Test
    func `A predicate disjoined with its complement accepts every value`() {

        let tautology = isEven || !isEven

        for n in -10...10 {
            #expect(tautology(n) == true)
        }
    }
}

@Suite
struct `Predicate exclusive disjunction obeys its truth table and algebraic laws` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `Static predicate XOR returns true when exactly one operand matches`(value: Int, expected: Bool) {
        let combined = Predicate.xor(isEven, isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
    ])
    func `The predicate XOR operator returns true when exactly one operand matches`(value: Int, expected: Bool) {
        let combined = isEven ^ isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
    ])
    func `Fluent predicate XOR returns true when exactly one operand matches`(value: Int, expected: Bool) {
        let combined = isEven.xor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func `XOR is commutative`() {
        let p1 = isEven ^ isPositive
        let p2 = isPositive ^ isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `XOR is associative`() {
        let isSmall = Predicate<Int> { abs($0) < 5 }

        let p1 = (isEven ^ isPositive) ^ isSmall
        let p2 = isEven ^ (isPositive ^ isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct `Predicate NAND and NOR agree with negated conjunction and disjunction` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func `Static predicate NAND negates the conjunction of its operands`() {
        let nand = Predicate.nand(isEven, isPositive)
        let notAnd = !(isEven && isPositive)

        for n in -10...10 {
            #expect(nand(n) == notAnd(n))
        }
    }

    @Test
    func `Fluent predicate NAND negates the conjunction of its operands`() {
        let nand = isEven.nand(isPositive)
        let notAnd = !(isEven && isPositive)

        for n in -10...10 {
            #expect(nand(n) == notAnd(n))
        }
    }

    @Test
    func `Static predicate NOR negates the disjunction of its operands`() {
        let nor = Predicate.nor(isEven, isPositive)
        let notOr = !(isEven || isPositive)

        for n in -10...10 {
            #expect(nor(n) == notOr(n))
        }
    }

    @Test
    func `Fluent predicate NOR negates the disjunction of its operands`() {
        let nor = isEven.nor(isPositive)
        let notOr = !(isEven || isPositive)

        for n in -10...10 {
            #expect(nor(n) == notOr(n))
        }
    }
}

@Suite
struct `Predicate implication and equivalence preserve their Boolean definitions` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func `Static predicate implies agrees with disjunction of the negated antecedent`() {
        let implies = Predicate.implies(isEven, isPositive)
        let notOr = !isEven || isPositive

        for n in -10...10 {
            #expect(implies(n) == notOr(n))
        }
    }

    @Test
    func `Fluent predicate implies agrees with disjunction of the negated antecedent`() {
        let implies = isEven.implies(isPositive)
        let notOr = !isEven || isPositive

        for n in -10...10 {
            #expect(implies(n) == notOr(n))
        }
    }

    @Test
    func `Static predicate iff agrees with negated exclusive disjunction`() {
        let iff = Predicate.iff(isEven, isPositive)
        let notXor = !(isEven ^ isPositive)

        for n in -10...10 {
            #expect(iff(n) == notXor(n))
        }
    }

    @Test
    func `Fluent predicate iff agrees with negated exclusive disjunction`() {
        let iff = isEven.iff(isPositive)
        let notXor = !(isEven ^ isPositive)

        for n in -10...10 {
            #expect(iff(n) == notXor(n))
        }
    }

}

@Suite
struct `Predicate negation obeys De Morgan laws` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }

    @Test
    func `Negated predicate conjunction equals disjunction of negated predicates`() {

        let p1 = !(isEven && isPositive)
        let p2 = !isEven || !isPositive

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `Negated predicate disjunction equals conjunction of negated predicates`() {

        let p1 = !(isEven || isPositive)
        let p2 = !isEven && !isPositive

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct `Predicate conjunction and disjunction distribute over each other` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }
    let isPositive = Predicate<Int> { $0 > 0 }
    let isSmall = Predicate<Int> { abs($0) < 5 }

    @Test
    func `AND distributes over OR`() {

        let p1 = isEven && (isPositive || isSmall)
        let p2 = (isEven && isPositive) || (isEven && isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `OR distributes over AND`() {

        let p1 = isEven || (isPositive && isSmall)
        let p2 = (isEven || isPositive) && (isEven || isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

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

@Suite
struct `Optional predicates distinguish absence and apply explicit defaults` {

    @Test
    func `Static optional lifting evaluates present values and uses false for absence`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let optionalIsEven = Predicate.optional(isEven, default: false)

        #expect(optionalIsEven(4) == true)
        #expect(optionalIsEven(3) == false)
        #expect(optionalIsEven(nil) == false)
    }

    @Test
    func `Instance optional lifting evaluates present values and uses false for absence`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let test = isEven.optional(default: false)

        #expect(test(4) == true)
        #expect(test(3) == false)
        #expect(test(nil) == false)
    }

    @Test
    func `Optional lifting uses the true default for absence`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        let test = isEven.optional(default: true)

        #expect(test(nil) == true)
    }
}

@Suite
struct `Predicate quantifiers evaluate matching elements across collections and ranges` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test(arguments: [
        (array: [2, 4, 6], expected: true),
        (array: [2, 3, 4], expected: false),
        (array: [], expected: true),
    ])
    func `Static all returns true exactly when every element matches`(array: [Int], expected: Bool) {
        let allEven: Predicate<[Int]> = Predicate.forAll(isEven)
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false),
    ])
    func `Static any returns true exactly when at least one element matches`(array: [Int], expected: Bool) {
        let anyEven: Predicate<[Int]> = Predicate.forAny(isEven)
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true),
    ])
    func `Static none returns true exactly when no element matches`(array: [Int], expected: Bool) {
        let noneEven: Predicate<[Int]> = Predicate.forNone(isEven)
        #expect(noneEven(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], expected: true),
        (array: [2, 3, 4], expected: false),
        (array: [], expected: true),
    ])
    func `Instance forAll returns true exactly when every element matches`(array: [Int], expected: Bool) {
        let allEven: Predicate<[Int]> = isEven.forAll()
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false),
    ])
    func `Instance forAny returns true exactly when at least one element matches`(array: [Int], expected: Bool) {
        let anyEven: Predicate<[Int]> = isEven.forAny()
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true),
    ])
    func `Instance forNone returns true exactly when no element matches`(array: [Int], expected: Bool) {
        let noneEven: Predicate<[Int]> = isEven.forNone()
        #expect(noneEven(array) == expected)
    }

    @Test
    func `Static for all returns true exactly when every set element matches`() {
        let allEven: Predicate<Set<Int>> = Predicate.forAll(isEven)

        #expect(allEven(Set([2, 4, 6])) == true)
        #expect(allEven(Set([2, 3, 4])) == false)
        #expect(allEven(Set()) == true)
    }

    @Test
    func `Static for any returns true exactly when at least one set element matches`() {
        let anyEven: Predicate<Set<Int>> = Predicate.forAny(isEven)

        #expect(anyEven(Set([1, 2, 3])) == true)
        #expect(anyEven(Set([1, 3, 5])) == false)
        #expect(anyEven(Set()) == false)
    }

    @Test
    func `Static for none returns true exactly when no set element matches`() {
        let noneEven: Predicate<Set<Int>> = Predicate.forNone(isEven)

        #expect(noneEven(Set([1, 3, 5])) == true)
        #expect(noneEven(Set([1, 2, 3])) == false)
        #expect(noneEven(Set()) == true)
    }

    @Test
    func `Instance for all returns true exactly when every set element matches`() {
        let allEven: Predicate<Set<Int>> = isEven.forAll()

        #expect(allEven(Set([2, 4, 6])) == true)
        #expect(allEven(Set([2, 3, 4])) == false)
        #expect(allEven(Set()) == true)
    }

    @Test
    func `Instance for any returns true exactly when at least one set element matches`() {
        let anyEven: Predicate<Set<Int>> = isEven.forAny()

        #expect(anyEven(Set([1, 2, 3])) == true)
        #expect(anyEven(Set([1, 3, 5])) == false)
        #expect(anyEven(Set()) == false)
    }

    @Test
    func `Instance for none returns true exactly when no set element matches`() {
        let noneEven: Predicate<Set<Int>> = isEven.forNone()

        #expect(noneEven(Set([1, 3, 5])) == true)
        #expect(noneEven(Set([1, 2, 3])) == false)
        #expect(noneEven(Set()) == true)
    }

    @Test
    func `Universal quantification requires every closed range element to match`() {
        let allEven: Predicate<ClosedRange<Int>> = isEven.forAll()

        #expect(allEven(2...2) == true)
        #expect(allEven(1...10) == false)
    }

    @Test
    func `Existential quantification requires a matching closed range element`() {
        let anyEven: Predicate<ClosedRange<Int>> = isEven.forAny()

        #expect(anyEven(1...10) == true)
        #expect(anyEven(1...1) == false)
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

    private final class Stream: Sequence, IteratorProtocol {
        var nextValue = 0
        var reads = 0
        func makeIterator() -> Stream { self }
        func next() -> Int? {
            guard nextValue < 5 else { return nil }
            reads += 1
            defer { nextValue += 1 }
            return nextValue
        }
    }

    @Test func `quantifiers short circuit and advance a single pass source`() {
        let source = Stream()
        let belowTwo = Predicate<Int> { $0 < 2 }
        let all: Predicate<Stream> = belowTwo.forAll()
        #expect(!all(source))
        #expect(source.reads == 3)
        #expect(source.nextValue == 3)

        let three = Predicate<Int> { $0 == 3 }
        let any: Predicate<Stream> = three.forAny()
        #expect(any(source))
        #expect(source.reads == 4)

        let four = Predicate<Int> { $0 == 4 }
        let none: Predicate<Stream> = four.forNone()
        #expect(!none(source))
        #expect(source.reads == 5)
    }
}
