# LLC: Low Level Calculator

    code: 1+2(3+4)-3
    ast: ((1+(2*(3+4)))-3)
         (- (+ 1 (* 2 (+ 3 4))) 3)
    ir: (print the-ast)
    llvm as: %tmp = ...
    llvm bc: ...
    executable: ...

## Requirements

* Ruby
  * RParsec
* LLVM
  * `llvm-as`
  * `lli`

## Author

Tatsuhiro Ujihisa
<http://ujihisa.blogspot.com/>
