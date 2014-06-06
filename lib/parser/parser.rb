require_relative "../lexer/lexer"
require_relative "./dot_syntax_exception"
require_relative "./ast"


class Parser
  def initialize(lexer)
    @lexer = lexer
    @lexer.tokenize
  end

  def parse_statement_list
    match_keyword(KeyWord::DIGRAPH)
    node = AST.new("DIGRAPH")
    node_with_child = match_id
    node.add_child(node_with_child)
    match(TokenType::LBRACE)
    while @lexer.lookahead_token.type != TokenType::RBRACE
      node_with_child.add_child(parse_statement)
    end
    match(TokenType::RBRACE)
    return node
  end

  def parse_statement
    return parse_appropriate_grammer_based_on_token
  end

  def parse_appropriate_grammer_based_on_token
    @lexer.advance_token
    token_type = @lexer.lookahead_token.type
    @lexer.revert_token
    if token_type == TokenType::ARROW
      return parse_edge_statement
    elsif @lexer.lookahead_token.type == KeyWord::NODE.upcase.to_sym
      parse_attr_statement
    else
      return parse_node_statement
    end
  end

  def parse_node_statement
    node = parse_node_id
    if @lexer.lookahead_token.type == TokenType::LBRACK
      node.add_child(parse_attr_list)
    end
    match(TokenType::RBRACK)
    match(TokenType::SEMICOLON)
    return node
  end

  def parse_edge_statement
    node = AST.new("ARROW")
    node.add_child(parse_node_id)
    node_with_child = parse_edgeRHS
    node.add_child(node_with_child)
    if @lexer.lookahead_token.type == TokenType::LBRACK
      node_with_child.add_child(parse_attr_list)
      while @lexer.lookahead_token && @lexer.lookahead_token.type == TokenType::COMMA
        match(TokenType::COMMA)
        node_with_child.add_child(parse_a_list)
      end
      match(TokenType::RBRACK)
    end
      match(TokenType::SEMICOLON)
    return node
  end

  def parse_attr_statement
    match_keyword(KeyWord::NODE)
    parse_attr_list
    match(TokenType::SEMICOLON)
  end

  def parse_edgeRHS
    match(TokenType::ARROW)
    return parse_node_id
  end

  def parse_attr_list
    match(TokenType::LBRACK)
    node = parse_a_list
    return node
  end

  def parse_a_list
    node = AST.new("ASSIGNMENT")
    node.add_child(match_id)
    match(TokenType::ASSIGNMENT)
    node.add_child(match_id)
    return node
  end

  def parse_node_id
    return match_id
  end

  def match_id
    check_for_nil_token(TokenType::ID)
    lookahead_type  = @lexer.lookahead_token.type
    lookahead_value = @lexer.lookahead_token.value
    node = AST.new(lookahead_value)
    if (lookahead_type == TokenType::ID ||
      lookahead_type == TokenType::NUMBER ||
      lookahead_type == TokenType::STRING)
      consume_token
    else
      raise_syntax_error(TokenType::ID, lookahead_type)
    end
    return node
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
  end

  def check_for_nil_token(expected)
    return if !@lexer.lookahead_token.nil?
    raise_syntax_error(expected, "NIL")
  end
end
