import Testing

@testable import Predicate_Primitives

@Suite
struct `Closure Operator Tests` {
    let isEven: (Int) -> Bool = { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isNegative: (Int) -> Bool = { $0 < 0 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
        (value: -3, expected: false),
    ])
    func `closure AND`(value: Int, expected: Bool) {
        let combined = isEven && isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -3, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: false),
    ])
    func `closure OR`(value: Int, expected: Bool) {
        let combined = isEven || isNegative
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `closure XOR`(value: Int, expected: Bool) {
        let combined = isEven ^ isPositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 3, expected: true),
        (value: 4, expected: false),
    ])
    func `closure NOT`(value: Int, expected: Bool) {
        let isOdd = !isEven
        #expect(isOdd(value) == expected)
    }

    @Test
    func `chained closure operations`() {
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
struct `Mixed Predicate Closure Operator Tests` {
    let predicateEven = Predicate<Int> { $0 % 2 == 0 }
    let predicatePositive = Predicate<Int> { $0 > 0 }
    let closureEven: (Int) -> Bool = { $0 % 2 == 0 }
    let closurePositive: (Int) -> Bool = { $0 > 0 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func `predicate AND closure`(value: Int, expected: Bool) {
        let combined = predicateEven && closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: false),
        (value: -4, expected: false),
    ])
    func `closure AND predicate`(value: Int, expected: Bool) {
        let combined = closureEven && predicatePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func `predicate OR closure`(value: Int, expected: Bool) {
        let combined = predicateEven || closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func `closure OR predicate`(value: Int, expected: Bool) {
        let combined = closureEven || predicatePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `predicate XOR closure`(value: Int, expected: Bool) {
        let combined = predicateEven ^ closurePositive
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `closure XOR predicate`(value: Int, expected: Bool) {
        let combined = closureEven ^ predicatePositive
        #expect(combined(value) == expected)
    }
}

@Suite
struct `Fluent Method Closure Tests` {
    let predicate = Predicate<Int> { $0 % 2 == 0 }
    let isPositive: (Int) -> Bool = { $0 > 0 }
    let isSmall: (Int) -> Bool = { abs($0) < 10 }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false),
        (value: 3, expected: false),
    ])
    func `fluent AND`(value: Int, expected: Bool) {
        let combined = predicate.and(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: true),
        (value: -3, expected: false),
    ])
    func `fluent OR`(value: Int, expected: Bool) {
        let combined = predicate.or(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
        (value: -3, expected: false),
    ])
    func `fluent XOR`(value: Int, expected: Bool) {
        let combined = predicate.xor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: true),
        (value: -4, expected: true),
    ])
    func `fluent NAND`(value: Int, expected: Bool) {
        let combined = predicate.nand(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: false),
        (value: 3, expected: false),
        (value: -3, expected: true),
    ])
    func `fluent NOR`(value: Int, expected: Bool) {
        let combined = predicate.nor(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: -4, expected: false),
        (value: 4, expected: true),
        (value: -3, expected: true),
        (value: 3, expected: true),
    ])
    func `fluent implies`(value: Int, expected: Bool) {
        let combined = predicate.implies(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: false),
        (value: 3, expected: false),
        (value: -3, expected: true),
    ])
    func `fluent iff`(value: Int, expected: Bool) {
        let combined = predicate.iff(isPositive)
        #expect(combined(value) == expected)
    }

    @Test(arguments: [
        (value: 4, expected: true),
        (value: -4, expected: true),
        (value: 3, expected: false),
        (value: -3, expected: true),
    ])
    func `fluent unless`(value: Int, expected: Bool) {
        let combined = predicate.unless(isPositive)
        #expect(combined(value) == expected)
    }

    @Test
    func `chained fluent methods`() {

        let combined = predicate.and(isPositive).or(isSmall)

        #expect(combined(4) == true)

        #expect(combined(8) == true)

        #expect(combined(-2) == true)

        #expect(combined(3) == true)

        #expect(combined(11) == false)
    }
}

@Suite
struct `Closure Commutativity Tests` {
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
struct `Closure Associativity Tests` {
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
struct `Closure Type Conversion Tests` {
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
