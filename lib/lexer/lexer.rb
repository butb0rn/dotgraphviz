require_relative "./token"
require_relative "./token_type"
require_relative "./key_word"

class Lexer
  def initialize(code)
    @code = code
    @tokens = []
    @current_token_index = 0
  end

  def tokenize
    @code.chomp!
    current_char_position = 0

    while current_char_position < @code.size
      chunk = @code[current_char_position..-1]
      if identifier = chunk[/\A([a-zA-Z]\w*)/, 1]
        if KeyWord::KEYWORDS.include?(identifier)
          @tokens << Token.new(identifier.upcase.to_sym, identifier)
        else
          @tokens << Token.new(TokenType::ID, identifier)
        end
        current_char_position += identifier.size
      elsif number = chunk[/\A([0-9]+)/, 1]
        @tokens << Token.new(TokenType::NUMBER, number.to_i)
        current_char_position += number.size
      elsif string = chunk[/\A"([^"]*)"/, 1]
        @tokens << Token.new(TokenType::STRING, string)
        current_char_position += string.size + 2
      elsif operator = /\A(->).*/.match(chunk)
        @tokens << Token.new(TokenType::ARROW, operator[1])
        current_char_position += 2
      elsif operator = chunk[/\A({)/, 1]
        @tokens << Token.new(TokenType::LBRACE, "{")
        current_char_position += 1
      elsif operator = chunk[/\A(})/, 1]
        @tokens << Token.new(TokenType::RBRACE, "}")
        current_char_position += 1
      elsif operator = chunk[/\A(\[)/, 1]
        @tokens << Token.new(TokenType::LBRACK, "[")
        current_char_position += 1
      elsif operator = chunk[/\A(\])/, 1]
        @tokens << Token.new(TokenType::RBRACK, "]")
        current_char_position += 1
      elsif chunk.match(/\A\/\*.*/)
        current_char_position += 2
        while !chunk.match(/\A\*\/.*/)
          current_char_position += 1
          chunk = @code[current_char_position..-1]
        end
        current_char_position += 2
      elsif chunk.match(/\A /)
        current_char_position += 1
      elsif chunk.start_with?("\n")
        current_char_position += 1
      elsif chunk.match(/\A\=.*/)
        @tokens << Token.new(TokenType::ASSIGNMENT, "=")
        current_char_position += 1
      elsif chunk.match(/\A\;.*/)
        @tokens << Token.new(TokenType::SEMICOLON, ";")
        current_char_position += 1
      elsif chunk.match(/\A\,.*/)
        @tokens << Token.new(TokenType::COMMA, ",")
        current_char_position += 1
      end
    end
    @tokens
  end

  def lookahead_token
    @tokens[@current_token_index]
  end

  def advance_token
    @current_token_index += 1
  end

  def revert_token
    @current_token_index -= 1
  end

  def reset_current_token_index
    @current_token_index = 0
  end
end


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

if __FILE__ == $0
  lexer = Lexer.new(code)
  tokenized = lexer.tokenize
#  tokenized.each { |token| puts token }
end
