require_relative "./lexer/lexer"
require_relative "./parser/parser"



healthy_code = <<-CODE
digraph G {
   main [shape=box]; /* this is a comment */
   make_string [label="make a\nstring"];
}

CODE

# Tokenizing the Code
lexer = Lexer.new(healthy_code)
tokenized = lexer.tokenize
#tokenized.each { |token| puts token }


# Parsing the Code
parser = Parser.new(lexer)
t = parser.parse_statement_list
puts t.to_string_tree



# main [shape=box]; /* missing the closing ] */
# main -> parse [weight=8];
# parse -> execute;
# main -> mirza [style=dotted]; /* missing the target node ID */
# main -> cleanup;
# execute -> make_string;
# init -> make_string;
# main -> printf [style=bold, label="asghar"]; /* missing value */
# make_string [label="make a\nstring"];
# node [shape=box,style=filled,color=".7 .3 1.0"];
