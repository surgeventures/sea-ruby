# Sea for Ruby

[![License badge](https://img.shields.io/github/license/surgeventures/sea-ruby.svg)](https://github.com/surgeventures/sea-ruby/blob/master/LICENSE.md)
[![Build status badge](https://img.shields.io/circleci/project/github/surgeventures/sea-ruby/master.svg)](https://circleci.com/gh/surgeventures/sea-ruby/tree/master)
[![Code coverage badge](https://img.shields.io/codecov/c/github/surgeventures/sea-ruby/master.svg)](https://codecov.io/gh/surgeventures/sea-ruby/branch/master)

Sea facilitates and abstracts away side-effects - an important aspect of your Elixir applications
that often gets lost between the lines. It does so in a way loosely inspired by the observer pattern
ie. by making the source event (here, represented by signal) aware of its listeners (here,
represented by observers).

This design choice, as opposed eg. to pubsub where producer is made unaware of consumers,
intentionally couples the signal with its observers in order to simplify the reasoning about
synchronous operations within single system. It was introduced as an optimal abstraction for
facilitating side-effect-like interactions between relatively uncoupled modules (or "contexts" if
you will) that interact with each other in synchronous way within single coherent system.

## Installation

Add `sea_observer` to your list of dependencies in `mix.exs`:

```ruby
gem :sea_observer
```

You may pick the newest version number from [Hex](https://hex.pm/packages/sea).

## Usage

Sea for Ruby is a port of the same concept initially designed for Elixir in a form of [sea-elixir]
package. Currently, I can't afford to convert the entire documentation of said package to Ruby
concepts (pull requests are welcome!), but that's not to say you're completely on your own when
using the Ruby package.

Comprehensive guides that'll lead you through concepts behind Sea can be found on
[HexDocs](https://hexdocs.pm/sea).

- [Getting started]
- [Building signals]
- [Organizing observers]
- [Decoupling contexts]
- [Defining side-effects responsibly]
- [Composing transactions]
- [Testing]
- [API reference]

They show Elixir code but the concepts remain the same, with following notes:

- *Building signals*: Elixir signals depend on native `defstruct` to become data containers and you
  can translate that to plain instance variables in Ruby signals (Sea doesn't decide for you how to
  initialize, validate and manage the signal payload - as you may want to use everything from plain object state to Protobuffs or JSON schemas)

- *Organizing observers*: Sea for Ruby expects `#handle_signal` class method on observer class or
  module so, just like in Elixir, you can make plain modules behave like observers (just like
  classes inheriting from `Sea::Observer` do) in order to route signals to module internals (like
  presented in [sample signal router])

- *Testing*: same concepts and reasoning still applies but Ruby is not as restrictive as Elixir when
  it comes to mocking (much to its harm...) so you'll most probably want to use your go-to solution
  for mocking away the signal's `#emit` function in order to remove the side-effects caused by
  specific signals from unit tests

You'll want to support the study of Elixir-focused guides with the Ruby port of the [invoicing_app]
sample application that implements a simple DDD project. There, Sea plays a key role in decoupling
contexts that interact with each other within a single database transaction.

## Motivation

Sea is a pattern library. As such it's really thin and technically unsophisticated (although it does
take care of some little details so you don't have to). But the real benefits come from the pattern
itself and its impact on your codebase.

* **expressiveness** - side-effects triggered via signals are easy to track and maintain in the
  growing codebase with growing number of interacting business contexts

* **transactional safety** - side-effects synchronously triggered inside database transactions
  get committed or rolled back together with the original change that caused them

* **uniformity** - signals & observers scattered across modules may follow a consistent naming
  convention to make their code more compact and the project structure more obvious

* **traceability** - by making signals aware of interested parties (observers) and emitting to
  them in defined order it's easy to trace the whole flow with side-effects

* **loose coupling** - signals facilitate construction of event payload that may (should) include
  uncoupled primitive types instead of structures and behaviors tied to specific domain

* **encapsulation** - as opposed to inline calls, side-effect logic implemented in observers
  reduces the external APIs that would otherwise be required to make the side-effect happen

* **self-documentation** - side-effects put in dedicated entity (signals) introduce a facility for
  documenting and expressing payload of domain events across the system

* **test isolation** - side-effects triggered via signals instead of via inline calls may be
  easily mocked away in order for signal origin to be tested without caring about them

* **sync & async unification** - plug async eventing solution as one of synchronous transactional
  side-effects to achieve reliable sync and async flows with single eventing syntax

[sea-elixir]: https://github.com/surgeventures/sea-elixir
[Getting started]: https://hexdocs.pm/sea/getting_started.html
[Building signals]: https://hexdocs.pm/sea/building_signals.html
[Organizing observers]: https://hexdocs.pm/sea/organizing_observers.html
[Decoupling contexts]: https://hexdocs.pm/sea/decoupling_contexts.html
[Defining side-effects responsibly]: https://hexdocs.pm/sea/defining_side_effects_responsibly.html
[Composing transactions]: https://hexdocs.pm/sea/composing_transactions.html
[Testing]: https://hexdocs.pm/sea/testing.html
[API reference]: https://hexdocs.pm/sea/api-reference.html
[invoicing_app]: https://github.com/surgeventures/sea-ruby/tree/master/examples/invoicing_app
[sample signal router]: https://github.com/surgeventures/sea-ruby/blob/master/examples/invoicing_app/lib/invoicing_app/signal_router.rb
