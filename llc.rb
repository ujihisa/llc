require 'rubygems'
require 'rparsec'

module LLC
  class LLCParser
    include RParsec
    include Parsers
    def parser
      ops = OperatorTable.new.
        infixl(char('+') >> lambda {|x, y| [:+, x, y] }, 20).
        infixl(char('-') >> lambda {|x, y| [:-, x, y] }, 20).
        infixl(char('*') >> lambda {|x, y| [:*, x, y] }, 40).
        infixl(char('/') >> lambda {|x, y| [:/, x, y] }, 40).
        prefix(char('+') >> lambda {|x| x }, 60).
        prefix(char('-') >> lambda {|x| [:*, -1, x] }, 60)
      expr = nil
      term0 = char('(') >> lazy { expr } << char(')')
      term = sequence(integer.map(&:to_i), term0) {|x, y| [:*, x, y] } |
        integer.map(&:to_i) |
        term0
      delim = whitespace.many_
      expr = delim >> Expressions.build(term, ops, delim)
    end
  end

  module_function

  def parse(code)
    LLCParser.new.parser.parse code
  end

  def compile(ast)
    header = <<-'E'
    @str = internal constant [4 x i8] c"%d\0A\00"
    define void @main() nounwind {
    E

    n = 0
    body = ''

    compile = lambda {|el|
      case el
      when Array
        n += 1
        m = n
        a, b, c = *el
        a = {:+ => 'add', :- => 'sub', :* => 'mul', :/ => 'udiv'}[a]
        b = compile[b]
        c = compile[c]
        body << "      %tmp#{m} = #{a} i32 #{b}, #{c}\n"
        #body << "      call i32 @printf(i8* getelementptr([4 x i8]* @str,i32 0,i32 0),i32 %tmp#{m})\n"
        "%tmp#{m}"
      else
        el
      end
    }
    compile[ast]

    footer = <<-'E'
      call i32 @printf(i8* getelementptr([4 x i8]* @str,i32 0,i32 0),i32 %tmp1)
      ret void
    }
    declare i32 @printf(i8*, ...) nounwind
    E
    header + body + footer
  end
end

if $0 == __FILE__
  ARGV.each do |a|
    if a == '--ast'
      ARGV.delete(a)
      p LLC.parse(ARGF.read)
      exit
    elsif a == '-S'
      ARGV.delete(a)
      puts LLC.compile(LLC.parse(ARGF.read))
      exit
    end
  end
  require 'tempfile'
  ast = LLC.parse ARGF.read
  as_code = LLC.compile(ast)
  file_ll = Tempfile.new('llc').path + '.ll'
  file_bc = file_ll.sub(/ll$/, 'bc')
  File.open(file_ll, 'w') {|io| io.puts as_code }
  system 'llvm-as', file_ll, '-o', file_bc
  system 'lli', file_bc
end
#'1(1) +2-3*4(3+4)+(-2) + (-(1+2)*3)' #=> -92
