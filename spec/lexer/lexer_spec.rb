require_relative "../../lib/lexer/lexer"

describe Lexer do
  it "tokenizes accurately" do
    code = <<-CODE
    digraph G {
      main [shape=box]; /* this is a comment */
      main -> parse [weight=8];
      parse -> execute;
      main -> init [style=dotted];
      main -> cleanup;
      execute -> make_string;
      init -> make_string;
      main -> printf [style=bold,label="100 times"];
      make_string [label="make a\nstring"];
      node [shape=box,style=filled,color=".7 .3 1.0"];
      execute -> compare;
    }
    CODE
    tokenized = Lexer.new(code).tokenize
    expected_tokens = [[:DIGRAPH, "digraph"], [:ID, "G"], [:LBRACE, "{"], [:ID, "main"], [:LBRACK, "["], [:ID, "shape"], 
      [:ASSIGNMENT, "="], [:ID, "box"], [:RBRACK, "]"], [:SEMICOLON, ";"], [:ID, "main"], [:ARROW, "->"], [:ID, "parse"], 
      [:LBRACK, "["], [:ID, "weight"], [:ASSIGNMENT, "="], [:NUMBER, 8], [:RBRACK, "]"], [:SEMICOLON, ";"], [:ID, "parse"], 
      [:ARROW, "->"], [:ID, "execute"], [:SEMICOLON, ";"], [:ID, "main"], [:ARROW, "->"], [:ID, "init"], [:LBRACK, "["], 
      [:ID, "style"], [:ASSIGNMENT, "="], [:ID, "dotted"], [:RBRACK, "]"], [:SEMICOLON, ";"], [:ID, "main"], [:ARROW, "->"], 
      [:ID, "cleanup"], [:SEMICOLON, ";"], [:ID, "execute"], [:ARROW, "->"], [:ID, "make_string"], [:SEMICOLON, ";"], [:ID, "init"], 
      [:ARROW, "->"], [:ID, "make_string"], [:SEMICOLON, ";"], [:ID, "main"], [:ARROW, "->"], [:ID, "printf"], [:LBRACK, "["], 
      [:ID, "style"], [:ASSIGNMENT, "="], [:ID, "bold"], [:COMMA, ","], [:ID, "label"], [:ASSIGNMENT, "="], [:STRING, "100 times"], 
      [:RBRACK, "]"], [:SEMICOLON, ";"], [:ID, "make_string"], [:LBRACK, "["], [:ID, "label"], [:ASSIGNMENT, "="], [:STRING, "make a\nstring"], 
      [:RBRACK, "]"], [:SEMICOLON, ";"], [:NODE, "node"], [:LBRACK, "["], [:ID, "shape"], [:ASSIGNMENT, "="], [:ID, "box"], [:COMMA, ","], 
      [:ID, "style"], [:ASSIGNMENT, "="], [:ID, "filled"], [:COMMA, ","], [:ID, "color"], [:ASSIGNMENT, "="], [:STRING, ".7 .3 1.0"], 
      [:RBRACK, "]"], [:SEMICOLON, ";"], [:ID, "execute"], [:ARROW, "->"], [:ID, "compare"], [:SEMICOLON, ";"], [:RBRACE, "}"]]
    expected_token_objects = []
    expected_tokens.each { |token| expected_token_objects << Token.new(token[0], token[1]) }
    tokenized.should == expected_token_objects
  end
end
