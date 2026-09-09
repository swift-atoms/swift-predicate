import Predicate
import Testing

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
