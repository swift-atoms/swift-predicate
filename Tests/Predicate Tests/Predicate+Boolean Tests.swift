import Predicate
import Testing

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

        let p = isEven && Predicate { _ in true }

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `Conjunction with never rejects every value`() {

        let p = isEven && Predicate { _ in false }

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

        let p = isEven || Predicate { _ in false }

        for n in -10...10 {
            #expect(p(n) == isEven(n))
        }
    }

    @Test
    func `Disjunction with always accepts every value`() {

        let p = isEven || Predicate { _ in true }

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
