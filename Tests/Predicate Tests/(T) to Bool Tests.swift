import Testing

@testable import Predicate

@Suite
struct `Boolean closure operators combine evaluation results` {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isNegative: (Int) -> Bool = { $0 < 0 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
        (value: -3, expected: false),
    ])
    func `Closure AND returns true when both operands match`(value: Int, expected: Bool) {
        let combined = isEven && isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -3, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: false),
    ])
    func `Closure OR returns true when either operand matches`(value: Int, expected: Bool) {
        let combined = isEven || isNegative
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `Closure XOR returns true when exactly one operand matches`(value: Int, expected: Bool) {
        let combined = isEven ^ isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `Closure NOT inverts the closure result`(value: Int, expected: Bool) {
        let isOdd = !isEven
        #expect(isOdd(value) == expected)
    }

    @Test
    func `Chained closure conjunction requires every condition to match`() {
        let isSmall: (Int) -> Bool = { abs($0) < 5 }
        let combined = isEven && isPositive && isSmall

        #expect(combined(2) == true)
        #expect(combined(4) == true)
        #expect(combined(6) == false)
        #expect(combined(3) == false)
        #expect(combined(-2) == false)
    }
}

@Suite
struct `Predicates combine with Boolean closures in either operand position` {
    let predicateEven = Predicate<Int> { $0 % 2 == 0 }
    let predicatePositive = Predicate<Int> { $0 > 0 }
    let closureEven: (Int) -> Bool = { $0 % 2 == 0 }
    let closurePositive: (Int) -> Bool = { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func `Predicate AND closure returns true when both operands match`(value: Int, expected: Bool) {
        let combined = predicateEven && closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func `Closure AND predicate returns true when both operands match`(value: Int, expected: Bool) {
        let combined = closureEven && predicatePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func `Predicate OR closure returns true when either operand matches`(value: Int, expected: Bool) {
        let combined = predicateEven || closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func `Closure OR predicate returns true when either operand matches`(value: Int, expected: Bool) {
        let combined = closureEven || predicatePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `Predicate XOR closure returns true when exactly one operand matches`(value: Int, expected: Bool) {
        let combined = predicateEven ^ closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `Closure XOR predicate returns true when exactly one operand matches`(value: Int, expected: Bool) {
        let combined = closureEven ^ predicatePositive
        #expect(combined(value) == expected)
    }
}

@Suite
struct `Fluent predicate methods combine Boolean closures according to their connective` {
    let predicate = Predicate<Int> { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isSmall: (Int) -> Bool = { abs($0) < 10 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false),
        (value: 3, expected: false),
    ])
    func `Fluent predicate AND returns true when both operands match with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.and(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func `Fluent predicate OR returns true when either operand matches with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.or(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `Fluent predicate XOR returns true when exactly one operand matches with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.xor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
    ])
    func `Fluent predicate NAND negates the conjunction of its operands with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.nand(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: false),
        (value: -3, expected: true),
    ])
    func `Fluent predicate NOR negates the disjunction of its operands with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.nor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: -4, expected: false),
        (value: 4, expected: true),
        (value: -3, expected: true),
        (value: 3, expected: true),
    ])
    func `Fluent predicate implies agrees with disjunction of the negated antecedent with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.implies(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false),
        (value: 3, expected: false),
        (value: -3, expected: true),
    ])
    func `Fluent predicate iff agrees with negated exclusive disjunction with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.iff(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: false),
        (value: -3, expected: true),
    ])
    func `Fluent predicate unless agrees with implication from the condition with a closure operand`(value: Int, expected: Bool) {
        let combined = predicate.unless(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func `Chained fluent methods preserve conjunction before disjunction`() {

        let combined = predicate.and(isPositive).or(isSmall)

        #expect(combined(4) == true)

        #expect(combined(8) == true)

        #expect(combined(-2) == true)

        #expect(combined(3) == true)

        #expect(combined(11) == false)
    }
}

@Suite
struct `Boolean closure conjunction disjunction and exclusive disjunction commute` {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }

    @Test
    func `closure AND is commutative`() {
        let p1 = isEven && isPositive
        let p2 = isPositive && isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `closure OR is commutative`() {
        let p1 = isEven || isPositive
        let p2 = isPositive || isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `closure XOR is commutative`() {
        let p1 = isEven ^ isPositive
        let p2 = isPositive ^ isEven

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct `Boolean closure conjunction disjunction and exclusive disjunction associate` {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isSmall: (Int) -> Bool = { abs($0) < 5 }

    @Test
    func `closure AND is associative`() {
        let p1 = (isEven && isPositive) && isSmall
        let p2 = isEven && (isPositive && isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `closure OR is associative`() {
        let p1 = (isEven || isPositive) || isSmall
        let p2 = isEven || (isPositive || isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }

    @Test
    func `closure XOR is associative`() {
        let p1 = (isEven ^ isPositive) ^ isSmall
        let p2 = isEven ^ (isPositive ^ isSmall)

        for n in -10...10 {
            #expect(p1(n) == p2(n))
        }
    }
}

@Suite
struct `Closure composition produces predicates that support further composition` {
    @Test
    func `closure operators return predicate`() {
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        let isPositive: (Int) -> Bool = { $0 > 0 }

        let andResult = isEven && isPositive
        let orResult = isEven || isPositive
        let xorResult = isEven ^ isPositive
        let notResult = !isEven

        #expect(andResult(4) == true)
        #expect(orResult(3) == true)
        #expect(xorResult(3) == true)
        #expect(notResult(3) == true)
    }

    @Test
    func `closure can be mixed with predicate methods`() {
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        let isPositive: (Int) -> Bool = { $0 > 0 }

        let combined = (isEven && isPositive).or(Predicate<Int> { $0 == 0 })

        #expect(combined(4) == true)
        #expect(combined(0) == true)
        #expect(combined(-4) == false)
    }
}
