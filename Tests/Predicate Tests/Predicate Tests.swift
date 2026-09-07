import Testing

@testable import Predicate

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

    @Test
    func `Static predicate invocation evaluates the supplied value`() {
        let isEven = Predicate<Int> { $0 % 2 == 0 }
        #expect(Predicate.callAsFunction(isEven, 4) == true)
        #expect(Predicate.callAsFunction(isEven, 3) == false)
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
struct `Predicate implication equivalence and unless preserve their Boolean definitions` {
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

    @Test
    func `Static predicate unless agrees with implication from the condition`() {
        let unless = Predicate.unless(isEven, condition: isPositive)
        let reversed = Predicate.implies(isPositive, isEven)

        for n in -10...10 {
            #expect(unless(n) == reversed(n))
        }
    }

    @Test
    func `Fluent predicate unless agrees with implication from the condition`() {
        let unless = isEven.unless(isPositive)
        let reversed = isPositive.implies(isEven)

        for n in -10...10 {
            #expect(unless(n) == reversed(n))
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
struct `Property predicates evaluate values selected by key paths` {
    struct Person {
        let age: Int
        let name: String
    }

    @Test
    func `A property predicate evaluates the selected age`() {
        let isAdult = Predicate<Person>.where(\.age, Predicate<Int> { $0 >= 18 })

        let adult = Person(age: 25, name: "Alice")
        let child = Person(age: 15, name: "Bob")

        #expect(isAdult(adult) == true)
        #expect(isAdult(child) == false)
    }

    @Test
    func `A property closure evaluates the selected name`() {
        let hasLongName = Predicate<Person>.where(\.name) { $0.count > 5 }

        let alice = Person(age: 25, name: "Alice")
        let alexander = Person(age: 30, name: "Alexander")

        #expect(hasLongName(alice) == false)
        #expect(hasLongName(alexander) == true)
    }

    @Test
    func `A fluent property predicate evaluates the selected age`() {
        let isAdult = Predicate<Person>.where(\.age, .greater.thanOrEqualTo(18))

        let adult = Person(age: 25, name: "Alice")
        let child = Person(age: 15, name: "Bob")

        #expect(isAdult(adult) == true)
        #expect(isAdult(child) == false)
    }
}

@Suite
struct `Optional predicates distinguish absence and apply explicit defaults` {
    @Test(arguments: [
        (value: nil as Int?, expected: true),
        (value: 42 as Int?, expected: false),
    ])
    func `The nil predicate matches absent values`(value: Int?, expected: Bool) {
        let isNil = Predicate<Int>.is.nil
        #expect(isNil(value) == expected)
    }

    @Test(arguments: [
        (value: 42 as Int?, expected: true),
        (value: nil as Int?, expected: false),
    ])
    func `The not nil predicate matches present values`(value: Int?, expected: Bool) {
        let isNotNil = Predicate<Int>.is.notNil
        #expect(isNotNil(value) == expected)
    }

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
        let allEven = Predicate.all(isEven)
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false),
    ])
    func `Static any returns true exactly when at least one element matches`(array: [Int], expected: Bool) {
        let anyEven = Predicate.any(isEven)
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true),
    ])
    func `Static none returns true exactly when no element matches`(array: [Int], expected: Bool) {
        let noneEven = Predicate.none(isEven)
        #expect(noneEven(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], expected: true),
        (array: [2, 3, 4], expected: false),
        (array: [], expected: true),
    ])
    func `Property all returns true exactly when every element matches`(array: [Int], expected: Bool) {
        let allEven = isEven.all
        #expect(allEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 2, 3], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [], expected: false),
    ])
    func `Property any returns true exactly when at least one element matches`(array: [Int], expected: Bool) {
        let anyEven = isEven.any
        #expect(anyEven(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [1, 2, 3], expected: false),
        (array: [], expected: true),
    ])
    func `Property none returns true exactly when no element matches`(array: [Int], expected: Bool) {
        let noneEven = isEven.none
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
struct `Predicate count quantifiers compare the number of matching elements` {
    let isEven = Predicate<Int> { $0 % 2 == 0 }

    @Test(arguments: [
        (array: [2, 4, 6], n: 2, expected: true),
        (array: [2, 4], n: 3, expected: false),
        (array: [2, 4, 6, 8], n: 3, expected: true),
    ])
    func `Static at least accepts when the matching element count reaches the lower bound`(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.atLeast(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4, 6, 8], n: 3, expected: false),
        (array: [2, 4], n: 5, expected: true),
    ])
    func `Static at most accepts when the matching element count does not exceed the upper bound`(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.atMost(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4], n: 3, expected: false),
        (array: [2, 4, 6, 8], n: 3, expected: false),
    ])
    func `Static exactly accepts when the matching element count equals the requested count`(array: [Int], n: Int, expected: Bool) {
        let predicate = Predicate.Count.exactly(isEven, n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [2, 3, 5], expected: false),
        (array: [], expected: true),
    ])
    func `Static zero accepts when the matching element count is zero`(array: [Int], expected: Bool) {
        let predicate = Predicate.Count.zero(isEven)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 3, 5], expected: true),
        (array: [1, 3, 5], expected: false),
        (array: [2, 4, 6], expected: false),
    ])
    func `Static one accepts when the matching element count is one`(array: [Int], expected: Bool) {
        let predicate = Predicate.Count.one(isEven)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 2, expected: true),
        (array: [2, 4], n: 3, expected: false),
    ])
    func `Instance at least accepts when the matching element count reaches the lower bound`(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.atLeast(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4, 6, 8], n: 3, expected: false),
    ])
    func `Instance at most accepts when the matching element count does not exceed the upper bound`(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.atMost(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 4, 6], n: 3, expected: true),
        (array: [2, 4], n: 3, expected: false),
    ])
    func `Instance exactly accepts when the matching element count equals the requested count`(array: [Int], n: Int, expected: Bool) {
        let predicate = isEven.count.exactly(n)
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [1, 3, 5], expected: true),
        (array: [2, 3, 5], expected: false),
    ])
    func `Instance zero accepts when the matching element count is zero`(array: [Int], expected: Bool) {
        let predicate = isEven.count.zero
        #expect(predicate(array) == expected)
    }

    @Test(arguments: [
        (array: [2, 3, 5], expected: true),
        (array: [1, 3, 5], expected: false),
    ])
    func `Instance one accepts when the matching element count is one`(array: [Int], expected: Bool) {
        let predicate = isEven.count.one
        #expect(predicate(array) == expected)
    }
}

@Suite
struct `Predicate factories preserve comparison membership and collection conditions` {
    @Test(arguments: [
        (value: 0, expected: true),
        (value: 1, expected: false),
    ])
    func `The equality factory matches the requested value`(value: Int, expected: Bool) {
        let isZero = Predicate<Int>.equal.to(0)
        #expect(isZero(value) == expected)
    }

    @Test(arguments: [
        (value: 0, expected: false),
        (value: 1, expected: true),
    ])
    func `The inequality factory rejects the requested value`(value: Int, expected: Bool) {
        let isNotZero = Predicate<Int>.not.equalTo(0)
        #expect(isNotZero(value) == expected)
    }

    @Test(arguments: [
        (value: "a" as Character, expected: true),
        (value: "b" as Character, expected: false),
    ])
    func `The collection membership factory matches contained values`(value: Character, expected: Bool) {
        let isVowel = Predicate<Character>.in.collection("aeiou")
        #expect(isVowel(value) == expected)
    }

    @Test(arguments: [
        (value: 3, threshold: 5, expected: true),
        (value: 5, threshold: 5, expected: false),
    ])
    func `The less than factory excludes its upper bound`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.less.than(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 5, threshold: 5, expected: true),
        (value: 6, threshold: 5, expected: false),
    ])
    func `The less than or equal factory includes its upper bound`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.less.thanOrEqualTo(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 6, threshold: 5, expected: true),
        (value: 5, threshold: 5, expected: false),
    ])
    func `The greater than factory excludes its lower bound`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.greater.than(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 5, threshold: 5, expected: true),
        (value: 4, threshold: 5, expected: false),
    ])
    func `The greater than or equal factory includes its lower bound`(value: Int, threshold: Int, expected: Bool) {
        let predicate = Predicate<Int>.greater.thanOrEqualTo(threshold)
        #expect(predicate(value) == expected)
    }

    @Test(arguments: [
        (value: 15, expected: true),
        (value: 12, expected: false),
        (value: 20, expected: false),
    ])
    func `The range membership factory matches contained values`(value: Int, expected: Bool) {
        let isTeenager = Predicate<Int>.in.range(13...19)
        #expect(isTeenager(value) == expected)
    }

    @Test(arguments: [
        (value: 10, expected: true),
        (value: 15, expected: false),
    ])
    func `The negated range membership factory rejects contained values`(value: Int, expected: Bool) {
        let outsideTeenage = Predicate<Int>.not.inRange(13...19)
        #expect(outsideTeenage(value) == expected)
    }

    @Test(arguments: [
        (value: [], expected: true),
        (value: [1], expected: false),
    ])
    func `The empty factory matches empty collections`(value: [Int], expected: Bool) {
        #expect(Predicate<[Int]>.is.empty(value) == expected)
    }

    @Test(arguments: [
        (value: [1], expected: true),
        (value: [], expected: false),
    ])
    func `The not empty factory matches nonempty collections`(value: [Int], expected: Bool) {
        #expect(Predicate<[Int]>.is.notEmpty(value) == expected)
    }

    @Test(arguments: [
        (value: [1, 2, 3], count: 3, expected: true),
        (value: [1, 2], count: 3, expected: false),
    ])
    func `The count factory matches the requested collection length`(value: [Int], count: Int, expected: Bool) {
        #expect(Predicate<[Int]>.has.count(count)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", substring: "ell", expected: true),
        (value: "hello", substring: "xyz", expected: false),
    ])
    func `The substring factory matches strings containing the requested text`(value: String, substring: String, expected: Bool) {
        #expect(Predicate<String>.contains.substring(substring)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", prefix: "hel", expected: true),
        (value: "hello", prefix: "xyz", expected: false),
    ])
    func `The prefix factory matches strings with the requested prefix`(value: String, prefix: String, expected: Bool) {
        #expect(Predicate<String>.has.prefix(prefix)(value) == expected)
    }

    @Test(arguments: [
        (value: "hello", suffix: "llo", expected: true),
        (value: "hello", suffix: "xyz", expected: false),
    ])
    func `The suffix factory matches strings with the requested suffix`(value: String, suffix: String, expected: Bool) {
        #expect(Predicate<String>.has.suffix(suffix)(value) == expected)
    }

    @Test(arguments: [
        (value: "red", expected: true),
        (value: "yellow", expected: false),
    ])
    func `The any equality factory matches one of the requested values`(value: String, expected: Bool) {
        let isPrimaryColor = Predicate<String>.equal.toAny(of: "red", "green", "blue")
        #expect(isPrimaryColor(value) == expected)
    }

    @Test(arguments: [
        (value: "yellow", expected: true),
        (value: "red", expected: false),
    ])
    func `The none equality factory rejects each requested value`(value: String, expected: Bool) {
        let isNotPrimaryColor = Predicate<String>.equal.toNone(of: "red", "green", "blue")
        #expect(isNotPrimaryColor(value) == expected)
    }
}

@Suite
struct `Identity predicates match the requested identifiers` {
    struct Item: Identifiable {
        let id: Int
        let name: String
    }

    @Test(arguments: [
        (item: Item(id: 1, name: "A"), targetId: 1, expected: true),
        (item: Item(id: 2, name: "B"), targetId: 1, expected: false),
    ])
    func `The identity factory matches the requested identifier`(item: Item, targetId: Int, expected: Bool) {
        let predicate = Predicate<Item>.has.id(targetId)
        #expect(predicate(item) == expected)
    }

    @Test(arguments: [
        (item: Item(id: 1, name: "A"), expected: true),
        (item: Item(id: 4, name: "D"), expected: false),
    ])
    func `The identity membership factory matches an identifier in the collection`(item: Item, expected: Bool) {
        let predicate = Predicate<Item>.has.id(in: [1, 2, 3])
        #expect(predicate(item) == expected)
    }
}
