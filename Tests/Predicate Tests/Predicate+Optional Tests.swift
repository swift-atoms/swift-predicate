import Predicate
import Testing

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
