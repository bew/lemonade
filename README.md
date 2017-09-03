# Lemonade

Lemonbar configuration framework

## Usage

See [the samples](samples/), they're ordered as a tutorial (not commented yet).

If you have `crystal` installed in your environment, you can run each sample directly, e.g:
```
$ ./samples/01_hello_world.cr
```
This will first compile the sample program, then run it.

## TODO next

Now:
- Specs
  * containers
  * caching
  * rendering
  * formatting
  * ...
- Block hierarchy dump
- Make my totolist in GH issues?

After:
- clickable areas
- event-based update

Later (optimization):
- rendering trace

Simple samples:
* Make a counter, with buttons + & -, to increment/decrement the counter, and randomly change the BG color (visual feedback).
* Progressbar, with a near-progressbar rendering (using unicode blocks?), and wheel-up/down to change the value (and trigger event (every steps?))


Note: Lemonbar refresh rates:

Refreshs are instant with lemonbar :100: : `100_000` simple (like hello world) refreshs in 5.3 seconds (`~19_000` Refresh per second (don't know about the actual FPS))


## Ideas about the framework

A lemonade config can have 1 or more lemon (a lemonbar instance).

### The `lemonade` binary

The `lemonade` binary is the lemonade compiler (uses `crystal` compiler under-the-hood), with helpers to create a config dir, compile a lemonade, and run it, e.g:

* Initialize a config directory in the CWD
```
$ mkdir ~/.lemonade && cd ~/.lemonade
$ lemonade init
```


* Build (every time) then run a specific lemonade
```
$ lemonade run <source.cr> [args...]
or without `run`:
$ lemonade <source.cr> [args...]
```

* Build a specific lemonade (group of bars)
```
$ lemonade build <source.cr> -o my_lemonade
```

* Run it as a binary?
```
$ ./my_lemonade [args...]
```

### Notes about possibilities

A lemonade config can dynamically create lemons, position them, and change them based on events coming from other lemons (in the same lemonade).

Example lemonade:
```
+-------------------------------------------------------+
|        +----+ +--+      +------+ +----------+         |
|        | L1 | |L2|      |  L3  | |    L4    |         |
|        +----+ +--+      +------+ +----------+         |
|                                                       |
|                                                       |
|                                                       |
|                                                       |
|               +----------------------+                |
|               |    L5 id:bottom      |                |
|               +----------------------+                |
+-------------------------------------------------------+
```

L1-5 are lemons. Each lemon can be given a unique ID (e.g: L5 has ID `bottom`).

**Events and actions** can be configured accross multiple lemons of the same lemonade, e.g: A click on a specific block of L1 can trigger an event on a specific block of L5, and change what is displayed.


## Contributing

1. Fork it ( https://github.com/bew/lemonade/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [bew](https://github.com/bew) Benoit de Chezelles - creator, maintainer
