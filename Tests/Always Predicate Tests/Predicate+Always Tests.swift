#if Always
import Predicate
import Testing

@Suite struct `Constant predicate integration` {
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

    @Test func `constant operations accept noncopyable scoped input`() {
        struct Source: ~Copyable, ~Escapable { }
        let test = Predicate<Source>(Always(true))
        let source = Source()
        let accepted = test(source)
        #expect(accepted)
    }
}
#endif
