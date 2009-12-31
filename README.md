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
