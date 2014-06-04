require_relative "../lexer/lexer"
require_relative "./dot_syntax_exception"

class Parser
  def initialize(lexer)
    @lexer = lexer
    @lexer.tokenize
  end

  def parse_statement_list 
    match_keyword(KeyWord::DIGRAPH)
    match_id
    match(TokenType::LBRACE)
    parse_statement
  end

  def parse_statement
    parse_appropriate_grammer_based_on_token
    @lexer.lookahead_token.type == TokenType::RBRACE ? 
      match(TokenType::RBRACE) : parse_statement
  end

  def parse_appropriate_grammer_based_on_token
    @lexer.advance_token
    token_type = @lexer.lookahead_token.type
    @lexer.revert_token
    if token_type == TokenType::ARROW
      parse_edge_statement
    elsif @lexer.lookahead_token.type == KeyWord::NODE.upcase.to_sym
      parse_attr_statement
    else
      parse_node_statement
    end
  end

  def parse_node_statement
    parse_node_id
    parse_attr_list if @lexer.lookahead_token.type == TokenType::LBRACK
    match(TokenType::SEMICOLON)
  end

  def parse_edge_statement
    parse_node_id
    parse_edgeRHS
    parse_attr_list if @lexer.lookahead_token.type == TokenType::LBRACK
    match(TokenType::SEMICOLON)
  end

  def parse_attr_statement
    match_keyword(KeyWord::NODE)
    parse_attr_list
    match(TokenType::SEMICOLON)
  end

  def parse_edgeRHS
    match(TokenType::ARROW)
    parse_node_id
  end

  def parse_attr_list
    match(TokenType::LBRACK)
    parse_a_list
    match(TokenType::RBRACK)
  end

  def parse_a_list
    match_id
    match(TokenType::ASSIGNMENT)
    match_id
    while @lexer.lookahead_token && @lexer.lookahead_token.type == TokenType::COMMA
      match(TokenType::COMMA)
      parse_a_list
    end
  end

  def parse_node_id
    match_id
  end

  def match_id
    check_for_nil_token(TokenType::ID)
    lookahead_type = @lexer.lookahead_token.type
    if lookahead_type == TokenType::ID || 
      lookahead_type == TokenType::NUMBER || 
      lookahead_type == TokenType::STRING
      consume_token
    else
      raise_syntax_error(TokenType::ID, lookahead_type)
    end
  end

  def match(token_type)
    check_for_nil_token(token_type)
    lookahead_type = @lexer.lookahead_token.type
    lookahead_type == token_type ? consume_token :
      raise_syntax_error(token_type, lookahead_type)
  end

  def match_keyword(keyword)
    check_for_nil_token(keyword)
    lookahead_value = @lexer.lookahead_token.value
    lookahead_value == keyword ? consume_token : 
      raise_syntax_error(keyword, lookahead_value)
  end

  def consume_token
    @lexer.advance_token
  end

  def raise_syntax_error(expected, actual)
    raise DotSyntaxException, "Expected: #{expected}\n Got: #{actual}"
    # TODO: improve error message
  end

  def check_for_nil_token(expected)
    return if !@lexer.lookahead_token.nil?
    raise_syntax_error(expected, "NIL")
  end
end
