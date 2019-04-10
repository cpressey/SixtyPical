SixtyPical
==========

_Version 0.19.  Work-in-progress, everything is subject to change._

**SixtyPical** is a [very low-level](#very-low-level) programming language
supporting a [sophisticated static analysis](#sophisticated-static-analysis).
Its reference compiler can generate [efficient code](#efficient-code) for
several 6502-based [target platforms](#target-platforms) while catching many
common mistakes at compile-time, reducing the time spent in debugging.

Quick Start
-----------

Make sure you have Python (2.7 or 3.5+) installed.  Then
clone this repository and put its `bin` directory on your
executable search path.  Then you can run:

    sixtypical

If you have the [VICE][] emulator installed, you can run

    ./loadngo.sh c64 eg/c64/hearts.60p

and it will compile the [hearts.60p source code](eg/c64/hearts.60p) and
automatically start it in the `x64` emulator, and you should see:

![Screenshot of result of running hearts.60p](images/hearts.png?raw=true)

You can try the `loadngo.sh` script on other sources in the `eg` directory
tree, which contains more extensive examples, including an entire
game(-like program); see [eg/README.md](eg/README.md) for a listing.

Features
--------

SixtyPical aims to fill this niche:

*   You'd use assembly, but you don't want to spend hours
    debugging (say) a memory overrun that happened because of a
    ridiculous silly error.
*   You'd use C or some other "high-level" language, but you don't
    want the extra overhead added by the compiler to manage the
    stack and registers.

SixtyPical gives the programmer a coding regimen on par with assembly
language in terms of size and hands-on-ness, but also able to catch
many ridiculous silly errors at compile time.

### Very low level

Many of SixtyPical's primitive instructions resemble
those of the 6502 CPU — in fact it is intended to be compiled to
6502 machine code — but along with these instructions are
constructs which ease structuring and analyzing the code.

However, SixtyPical also does provide some "higher-level" operations
based on common 8-bit machine-language programming idioms, including

*   copying values from one register to another (via a third register when
    there are no underlying instructions that directly support it)
*   copying, adding, and comparing 16-bit values (done in two steps)
*   explicit tail calls
*   indirect subroutine calls

While a programmer will find these constructs convenient, their
inclusion in the language is primarily to make programs easier to analyze.

### Sophisticated static analysis

The language defines an [effect system][], and the reference
compiler [abstractly interprets][] the input program to check that
it conforms to it.  It can detect common mistakes such as

*   you forgot to clear carry before adding something to the accumulator
*   a subroutine that you called trashes a register you thought it preserved
*   you tried to read or write a byte beyond the end of a byte array
*   you tried to write the address of something that was not a routine, to
    a jump vector

### Efficient code

Unlike most languages, in SixtyPical the programmer must manage memory very
explicitly, selecting the registers and memory locations to store all data in.
So, unlike a C compiler such as [cc65][], a SixtyPical compiler doesn't need
to generate code to handle [call stack management][] or [register allocation][].
This results in smaller (and thus faster) programs.

The flagship demo, a minigame for the Commodore 64, compiles to
a **930**-byte `.PRG` file.

### Target platforms

The reference implementation can analyze and compile SixtyPical programs to
6502 machine code formats which can run on several 6502-based 8-bit architectures:

*   [Commodore 64][]
*   [Commodore VIC-20][]
*   [Atari 2600][]
*   [Apple II series][]

For example programs for each of these, see [eg/README.md](eg/README.md).

Documentation
-------------

SixtyPical is defined by a specification document, a set of test cases,
and a reference implementation written in Python.

*   [Design Goals](doc/Design%20Goals.md)
*   [SixtyPical specification](doc/SixtyPical.md)
*   [SixtyPical revision history](HISTORY.md)
*   [Literate test suite for SixtyPical syntax](tests/SixtyPical%20Syntax.md)
*   [Literate test suite for SixtyPical analysis](tests/SixtyPical%20Analysis.md)
*   [Literate test suite for SixtyPical compilation](tests/SixtyPical%20Compilation.md)
*   [Literate test suite for SixtyPical fallthru optimization](tests/SixtyPical%20Fallthru.md)
*   [6502 Opcodes used/not used in SixtyPical](doc/6502%20Opcodes.md)
*   [Output formats supported by `sixtypical`](doc/Output%20Formats.md)
*   [TODO](TODO.md)

[effect system]: https://en.wikipedia.org/wiki/Effect_system
[abstractly interprets]: https://en.wikipedia.org/wiki/Abstract_interpretation
[call stack management]: https://en.wikipedia.org/wiki/Call_stack
[register allocation]: https://en.wikipedia.org/wiki/Register_allocation
[VICE]: http://vice-emu.sourceforge.net/
[cc65]: https://cc65.github.io/
[Commodore 64]: https://en.wikipedia.org/wiki/Commodore_64
[Commodore VIC-20]: https://en.wikipedia.org/wiki/Commodore_VIC-20
[Atari 2600]: https://en.wikipedia.org/wiki/Atari_2600
[Apple II series]: https://en.wikipedia.org/wiki/Apple_II_series
