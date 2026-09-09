import Predicate
import Testing

@Suite
struct `Sequence accepts Predicate values` {
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
    @Test func `direct matching operations preserve standard sequence behavior`() {
        let even = Predicate<Int> { $0 % 2 == 0 }
        #expect([2, 4].allSatisfy(even))
        #expect([Int]().allSatisfy(even))
        #expect(![Int]().contains(where: even))
        #expect((1...4).contains(where: even))
        #expect((1...4).first(where: even) == 2)
        #expect([1, 3].first(where: even) == nil)
    }

    @Test func `direct operations short circuit a single pass source`() {
        let source = Stream()
        var calls = 0
        let two = Predicate<Int> { calls += 1; return $0 == 2 }
        #expect(source.contains(where: two))
        #expect(calls == 3)
        #expect(source.nextValue == 3)
        #expect(source.first(where: Predicate { $0 == 3 }) == 3)
        #expect(source.nextValue == 4)
    }
}
