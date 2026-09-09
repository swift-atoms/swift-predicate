# swift-predicate

A `Predicate<T>` is a stored Boolean function that borrows its input. The core
supports noncopyable and scoped inputs without consuming them.

```swift
let positive = Predicate<Int> { $0 > 0 }
let even = Predicate<Int> { $0 % 2 == 0 }
let positiveEven = positive && even
let allPositive: Predicate<[Int]> = positive.forAll()
```

The essential representation and evaluation live in `Predicate.swift`. Boolean
composition and dependency-free Optional/Swift Sequence lifting remain Predicate
extensions. Boolean composition does not depend on swift-algebra.

## Traits

| Trait | Independent operation | Predicate interpretation |
| --- | --- | --- |
| Contramap | Borrowed source projection | Input adaptation and pullback |
| Always | Stored constant | Constant truth values |
| Optic | Borrowed focus visitation | Universal/existential evaluation of focuses |

All three traits are enabled by default. A dependency can select traits explicitly
or use `traits: []` for the core without these integrations. Requests are additive
across the package graph. Conversion initializers construct the existing Predicate function
representation, avoiding an additional protocol or adapter hierarchy.

```swift
let length = Contramap { (text: borrowing String) in text.count }
let longName = Predicate(length, satisfying: Predicate<Int> { $0 > 3 })
let constant = Predicate<String>(Always(true))
```

`pullback` borrows its source, projects exactly once, then borrows the owned result
for evaluation. Noncopyable and scoped sources are supported; projected values
may be noncopyable but must be escapable. Throwing Contramap operations remain
valid independently, but cannot become a nonthrowing Predicate without an explicit
failure policy. This integration accepts only `Failure == Never`.

`Predicate(allSatisfying:in:)` and `Predicate(anySatisfying:in:)` accept an
Optic.Fold and borrow both source and focus,
including scoped/noncopyable values. No visits mean true for universal evaluation
and false for existential evaluation. The visitation callback cannot cancel the
optic's traversal; predicate evaluation stops after the first decisive result.
Lens, Prism, and Affine conversions use the existing Fold initializers. Those
conversions require copyable sources where the underlying optic consumes them;
the integration does not hide a copy of a noncopyable source.

Optional lifting retains an explicit absence default. `forAll`, `forAny`, and
`forNone` short circuit over Swift Sequence. Empty sequences satisfy `forAll` and
`forNone`, but not `forAny`. Evaluating a single-pass sequence advances its
underlying iterator. Infinite sequences may not terminate. These Swift adapters
have narrower ownership constraints than the borrowed core.

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

## Standard-library integration

Files under `Sources/Swift/Swift.X+Predicate.swift` extend the named
Swift standard-library type or protocol. Core Predicate extensions stay under `Sources/Predicate`. Trait integrations
live under `Sources/Always`, `Sources/Contramap`, and `Sources/Optic`, including
their extensions of Predicate. All sources compile into the same Predicate module.

`Swift.Sequence+Predicate.swift` adds `allSatisfy`, `contains(where:)`, and
`first(where:)` overloads accepting Predicate. `Predicate+Sequence.swift` owns
predicate quantification (`forAll`, `forAny`, and `forNone`). Arrays, slices,
strings, sets, dictionaries, and iterable ranges inherit the Sequence overloads;
they do not each need a duplicate integration file.

Further standard-library extension candidates, only where there is a distinct
operation accepting a Predicate:

| Swift abstraction | Candidate integration |
| --- | --- |
| Collection | `firstIndex(where:)` and boundary operations |
| BidirectionalCollection | `last(where:)` and `lastIndex(where:)` |
| MutableCollection | `partition(by:)` |
| RangeReplaceableCollection | `removeAll(where:)` |
| LazySequenceProtocol | Lazy filtering |

Optional lifting and key-path pullback extend Predicate, so they remain in
`Sources/Predicate`. Neither justifies a Swift.Optional or Swift.KeyPath extension
file on its own.

Filtering needs a coordinated design: Sequence returns an Array, lazy sequences
preserve laziness, and Dictionary has a dictionary-preserving filter. It is left
out of this first integration rather than changing those result shapes.

Range/ClosedRange/Set membership factories and String/Regex matching factories
remain optional domain conveniences, not required integration. Ordinary
Predicate closures already express them. Foundation types are outside this
standard-library inventory.

## Test organization

`Predicate Tests` covers the core, Boolean composition, Optional lifting, and
Sequence quantification. `Always Predicate Tests`, `Contramap Predicate Tests`,
and `Optic Predicate Tests` each cover one trait. `Swift Predicate Tests` covers
extensions of standard-library types. Source files have corresponding test files.

The `Predicate Integration Review` scheme in `parser.xcworkspace` runs these
five test targets and the independent `Contramap Tests` target using local
package resolution.
