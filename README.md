# LLC: Low Level Calculator

LLC compiles given calculating formula to LLVM Assembly Language, and runs it.

## USAGE

    $ echo '1 + 2(3+4) - 10/2' | ruby llc.rb
    10

    $ echo '1 + 2(3+4) - 10/2' | ruby llc.rb --ast
    $ echo '1 + 2(3+4) - 10/2' | ruby llc.rb -S > a.ll
    $ echo '1 + 2(3+4) - 10/2' | ruby llc.rb --run (default)

## Requirements

* Ruby
  * RParsec
* LLVM
  * `llvm-as`
  * `lli`

## Author

Tatsuhiro Ujihisa
<http://ujihisa.blogspot.com/>

## Benchmark

Whole Task of LLC

    $ time echo '1 + 2(3+4) - 10/2' | ruby llc.rb
    10
    echo '1 + 2(3+4) - 10/2'  0.00s user 0.00s system 9% cpu 0.009 total
    ruby llc.rb  0.47s user 0.11s system 93% cpu 0.618 total

Only Run Time

    $ echo '1 + 2(3+4) - 10/2' | ruby llc.rb -S > a.ll
    $ llvm-as a.ll
    $ time lli a.bc
    10
    lli a.bc  0.01s user 0.01s system 62% cpu 0.032 total

Pure Ruby

    $ time ruby -e 'puts 1 + 2*(3+4) - 10/2'
    10
    ruby -e 'puts 1 + 2*(3+4) - 10/2'  0.01s user 0.00s system 47% cpu 0.022 total
