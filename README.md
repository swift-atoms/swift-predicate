# swift-predicate

A `Predicate<T>` is a stored Boolean function that borrows its input. The core
supports noncopyable and scoped inputs without consuming them.

```swift
let positive = Predicate<Int> { $0 > 0 }
let even = Predicate<Int> { $0 % 2 == 0 }
let positiveEven = positive && even
let allPositive: Predicate<[Int]> = positive.forAll()
```

The package owns predicate evaluation, constants, Boolean composition, pullback,
optional lifting, and Sequence quantification. It has no external dependencies.

`forAll`, `forAny`, and `forNone` short circuit. Empty sequences satisfy `forAll`
and `forNone`, but not `forAny`. Evaluating a single-pass sequence advances its
underlying iterator; evaluation is not promised to be repeatable or nonmutating.
An infinite sequence may not terminate when no decisive element is reached.

Pullback, optional lifting, and Swift Sequence adapters currently have narrower
ownership constraints than the borrowed core. The package does not promise
scoped projections or noncopyable Swift Sequence elements.

## Removed conveniences

Comparison, membership, string, regex, identity, and emptiness factories are
expressed with ordinary closures, such as `Predicate<String> { $0.isEmpty }`.
The grammatical namespaces (`Contains`, `Has`, `Is`, `Equal`, `Not`, `Less`,
`Greater`, `In`, and `Matches`) and array-only `Count` API have been removed.

Use explicit `Predicate` construction before combining closures. Use `pullback`
instead of `where`, `implies` instead of the former ambiguous `unless`, and
`forAll`/`forAny`/`forNone` instead of the array-only `all`/`any`/`none` family.
Invoke a predicate with `predicate(value)` instead of static `callAsFunction`.

The empty Foundation Integration and Test Support products have been removed;
import `Predicate` directly.
